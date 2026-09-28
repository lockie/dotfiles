---
name: media-transcription
description: Transcribe any audio or video file (meeting recordings, interviews, lectures, podcasts, voice notes, videos) into text using the locally installed whisper-cli, save the transcript to a .md file next to the source, and deliver a summary of the content as the final result. Use this skill whenever the user mentions transcription, transcribing, speech-to-text, converting a recording to text or a written version, getting a transcript of a meeting/lecture/interview/podcast/video/voice note, asking what was said in a recording, or generating SRT subtitles from audio or video — even if the word "transcribe" never appears.
---

## Overview

Turn any recording — meeting video, interview audio, lecture capture, podcast episode, voice note — into a clean text transcript saved to disk, plus a summary delivered in chat. The summary is the end result the user wants; the transcript file is the artifact that outlives the conversation.

Everything runs locally: `ffmpeg` extracts the audio, `whisper-cli` (whisper.cpp) does the speech recognition. No network calls, nothing leaves the machine.

## System specifics

- Binary: `/usr/bin/whisper-cli`
- GPU: whisper-cli uses Vulkan acceleration when available — large-v2 transcribes at ~5× real-time with it (~1:1 when forced to CPU).
- Models in `/usr/share/whisper/ggml-models/`:
  - `large-v2.bin` (~3 GB) — default. Best accuracy. ~5× real-time on GPU, ~1:1 real-time on CPU (a 30-min recording: ~6 min on GPU, ~30 min on CPU).
  - `base.bin` (~150 MB) — roughly 20× real-time even on CPU, noticeably less accurate. Good for quick drafts, coverage checks (see step 6), or when the user just needs the gist of a very long recording. Offer it as an option for recordings longer than ~an hour.

## Performance expectations

Whisper speed depends on whether the GPU is usable, so measure before promising anything:

- Use `ffprobe` to get the duration **before** starting, so you can give the user a realistic ETA.
- Media longer than ~10 minutes: run whisper as a **background job** (`eca__shell_command` with the `background` parameter), then poll periodically, using sleep via `eca__bg_job`. Never hold a foreground shell for an hour.
- Short clips (≤ ~10 min on GPU, ≤ ~5 min on CPU): inline run is fine — set the command timeout to at least 2× the media duration.
- Never run two transcriptions in parallel. Two large-v2 instances (~3 GB each) exhaust GPU memory and crash with out-of-memory — this is the most common failure mode on this machine. If the user asks for several recordings, process them **sequentially**.
- The user already knows it's slow — don't warn them about the speed.

## Workflow

### 1. Identify the input

If the user didn't point at a specific file, check the current working directory for media files first — "transcribe the meeting recording" usually means one is sitting right there. If it's still ambiguous, ask. Common extensions: `.mp4`, `.mkv`, `.webm`, `.mov`, `.avi`, `.mp3`, `.m4a`, `.aac`, `.ogg`, `.opus`, `.wav`, `.flac`. Any format ffmpeg can read works, since the audio always gets converted first.

### 2. Measure duration

```bash
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 FILE
```

ETA ≈ duration ÷ 5 with large-v2 on GPU (÷ ~20 with base). If the GPU is unavailable and you fall back to CPU (see below), ETA ≈ duration. Tell the user the estimate, then decide inline vs background (see above).

### 3. Prepare the audio

Convert to 16 kHz mono PCM WAV — always, even for formats whisper accepts natively. One uniform pipeline avoids codec quirks:

```bash
ffmpeg -y -i INPUT -vn -acodec pcm_s16le -ar 16000 -ac 1 /tmp/BASE_mono.wav
```

`BASE` is the source filename without extension (avoids collisions between jobs). Flags: `-vn` strips video, `pcm_s16le` is uncompressed 16-bit PCM (best accuracy), `-ar 16000` is whisper's native sample rate, `-ac 1` downmixes to mono.

### 4. Transcribe

```bash
whisper-cli \
  -m /usr/share/whisper/ggml-models/large-v2.bin \
  -t 6 \
  -l auto \
  -otxt \
  -of OUTPUT_DIR/BASE \
  -f /tmp/BASE_mono.wav
```

- `-of` — output path **without extension** (whisper appends `.txt`). Point it at the source file's directory so the raw output lives next to the recording; if that directory isn't writable, use `/tmp/` and copy the results afterwards.
- `-l auto` — detect language. If the user named the language, pass it instead (`en`, `ru`, …) — slightly more accurate.
- Timestamps are **on by default** (`[hh:mm:ss.mmm --> ...` prefixes in the raw text) and that's deliberate: they cost nothing, get stripped in post-processing, and enable coverage checks (step 6) and chronological merging. Add `-nt` (no timestamps) only for quick gist runs you'll never verify.
- `-t 6` — 6 threads.
- `-pp` — optional; prints progress percentages to stderr. Add it when running as a background job so the polled output shows how far along it is.

**GPU failure → CPU fallback:** if whisper-cli dies during model load or early decoding with a Vulkan out-of-memory or device-lost error (typically when VRAM is tight or another whisper instance ran recently), retry the exact same command with `-ng` appended — it forces CPU-only execution. This changes the ETA from ~5× real-time to ~1× real-time, so mention the new estimate to the user and switch to a background job if the recording is longer than ~5 minutes.

For **SRT subtitles**, replace `-otxt` with `-osrt` (or use `-otxt -osrt` for both).

Do **not** use `--diarize` — it is unreliable on this setup and produces hallucinated output instead of real transcription.

### 5. Poll for completion (background jobs)

Poll periodically, using sleep via `eca__bg_job` (60–120 s intervals), and `read_output` to see whisper's stderr progress. The job is done when the process has exited and the output `.txt`/`.srt` exists with nonzero size — the log's final `whisper_print_timings` block is the usual completion signature. If the log ends with a Vulkan out-of-memory or device-lost error instead, apply the `-ng` fallback from step 4.

### 6. Verify coverage (when completeness matters)

large-v2 occasionally **drops whole passages** — a 25-second stretch of real speech was observed missing from a 2-minute transcript. For casual gist requests you can skip this check; for anything the user will rely on (meeting minutes, decisions, records), verify. Windowing needs timestamps in both outputs, which the step-4 default provides:

1. Run a second, cheap pass with the base model: roughly 20× real-time, so it costs little even for long recordings.
2. Compare the two outputs in ~30-second windows. A window where large-v2 produced little or no text but base produced substantial text is a suspected drop. (Large-v2 producing *more* text than base in a window is normal — it's the more accurate model.)
3. To recover a dropped region: cut it out (`ffmpeg -ss START -t LEN` with the same conversion flags as step 3), re-run large-v2 on the cut, and splice the recovered text into the transcript at the right place.

This same targeted-cut technique also settles disputed words: re-transcribe a few seconds around an ambiguous word and compare readings — but weigh the result against domain context, since whisper can consistently mis-hear jargon (e.g. Clojure as "closure"). When a word stays ambiguous, keep the more plausible reading and annotate the alternative in the transcript rather than silently guessing.

### 7. Post-process into a transcript file

Whisper's raw `.txt` is one unbroken block of timestamped text. Turn it into `BASE_transcript.md` next to the source:

1. Read the `.txt` in chunks (`eca__read_file` with `limit`) — an hour of speech is ~8–10k words; for very long transcripts consider a subagent for this step so your own context isn't consumed.
2. Split into paragraphs at natural boundaries: topic shifts, speaker changes, question→answer transitions (long timestamp gaps are a useful hint). In dialogues, format speaker turns as Markdown blockquotes or with an em dash (`—`) at the start of each turn.
3. Write the `.md` with a top-level heading (source name, plus date if known), readable paragraphs, and **no timestamps** — strip the `[hh:mm:ss.mmm --> ...]` prefixes. Flag probable mis-hearings inline (`"closure"` → Clojure) — the user knows the context and can spot what whisper got wrong.
4. Keep the raw `.txt` as a safety net — don't delete it.

### 8. Summarize — the final result

Once the transcript file is written, read it and produce a summary in chat. This summary is what the user asked for; end your reply with it (and mention the transcript file path). Adapt the shape to the content:

- **Meetings/standups** — decisions made, action items (with owners and deadlines when stated), key discussion points, open questions.
- **Lectures/talks** — main thesis and the key takeaways.
- **Interviews** — topics covered and notable answers.
- **Voice notes** — the gist and any tasks mentioned.

Scale length to content: a 2-minute voice note gets a couple of sentences; an hour-long meeting gets a structured breakdown. Quote exact wording only where precision matters (decisions, action items, numbers). Write the summary in the language the user is conversing in, regardless of the recording's language.

### 9. Clean up

Remove the temp WAV from `/tmp/`. Keep the raw whisper output and the `_transcript.md`.

## Advanced: one speaker per stereo channel

Some setups (e.g. call recorders) capture each speaker on a separate channel. If the user wants speaker labels and the source is stereo with separated speakers: extract each channel with the `pan` filter — `-af "pan=mono|c0=c0"` for the left channel, `-af "pan=mono|c0=c1"` for the right (plus the same conversion flags as step 3; note `-map_channel` no longer exists in ffmpeg 7+), transcribe each **sequentially** (timestamps, on by default, are required), then merge the two transcripts chronologically by timestamp, label the speakers, and strip timestamps from the final output. This doubles total transcription time — only do it on request.
