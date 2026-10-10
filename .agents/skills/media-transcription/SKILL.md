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

### 1. Identify the input — file, language, speakers

If the user didn't point at a specific file, check the current working directory for media files first — "transcribe the meeting recording" usually means one is sitting right there. If it's still ambiguous, ask. Common extensions: `.mp4`, `.mkv`, `.webm`, `.mov`, `.avi`, `.mp3`, `.m4a`, `.aac`, `.ogg`, `.opus`, `.wav`, `.flac`. Any format ffmpeg can read works, since the audio always gets converted first.

When starting a job, ask the user for two inputs that materially affect the result (one question, don't interrogate twice):

- **Language** of the recording — goes straight into whisper's `-l` flag; a known language is measurably more accurate than auto-detection. If the user doesn't know or care, `-l auto` detects it well enough.
- **Number of speakers** — whisper has no speaker-count parameter (and `--diarize` is off the table), but the count drives post-processing: how to label dialogue turns and whether to offer the split-channel technique for stereo call recordings. If unknown, infer it from the transcript content in step 7 and note the assumption.

If the user already implied either (e.g. "our standup recording, in English") or clearly wants zero back-and-forth, don't ask — use what you have and fall back to the defaults above.

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
  -of /tmp/BASE \
  -f /tmp/BASE_mono.wav
```

- `-of` — output path **without extension** (whisper appends `.txt`/`.json`). Always write raw output to `/tmp/`, never next to the recording: the source directory must end up containing only the recording and the final `_transcript.md` (see step 9).
- `-l auto` — detect language. If step 1 established the language, pass it instead (`en`, `ru`, …) — it's more accurate.
- Timestamps: in this whisper-cli build the `.txt` output has **no** timestamps — they only go to stderr and are lost. Add `-oj` so you get a JSON file with per-segment timings (`transcription[].offsets.from` / `.to`, in **milliseconds**). The JSON is what enables coverage checks (step 6) and chronological channel merging; the `.txt` is only a human-readable convenience.
- `-t 6` — 6 threads.
- `-pp` — optional; prints progress percentages to stderr. Add it when running as a background job so the polled output shows how far along it is.

**GPU failure → CPU fallback:** if whisper-cli dies during model load or early decoding with a Vulkan out-of-memory or device-lost error (typically when VRAM is tight or another whisper instance ran recently), retry the exact same command with `-ng` appended — it forces CPU-only execution. This changes the ETA from ~5× real-time to ~1× real-time, so mention the new estimate to the user and switch to a background job if the recording is longer than ~5 minutes.

For **SRT subtitles**, replace `-otxt` with `-osrt` (or use `-otxt -osrt` for both). An SRT the user asked for is a deliverable, not a leftover: copy it next to the source as `BASE.srt`.

Do **not** use `--diarize` — it is unreliable on this setup and produces hallucinated output instead of real transcription.

### 4b. Silence hallucination and repetition loops — check after EVERY run

Whisper routinely **mis-classifies silence and near-silence as speech** and then hallucinates: subtitle-credit lines ("Спасибо за субтитры…", "Thanks for watching"), or the last real phrase repeated over and over. Two severities:

- **Bounded runs** — a stretch of N consecutive identical segments at a silence inside an otherwise fine transcript. Common, harmless: strip in post (in runs of ≥3 identical consecutive segments keep only the first; a run of exactly 2 may be genuine repetition).
- **Full-file lock** — the *entire* output is one repeated line, even though the audio obviously contains speech. Whisper falls into a repetition attractor early (the file head doesn't even need to be silent) and never escapes. The transcript looks plausible in size but is 100% garbage — always check before trusting a long output.

Detection (cheap, scriptable from the `-oj` JSON):

1. Consecutive duplicates: scan for runs of identical `text` values. If most segments are in runs, or the file is one line repeated → hallucination lock.
2. Within-segment loops: loops also hide inside a single segment's text (one segment containing "я думаю, что мы уже почти кончили" ×20). Scan with a repetition regex such as `(.{10,60}?)\1{2,}`.

Before re-running anything, distinguish **loop lock** from **genuinely bad audio**: transcribe a 60-s cut from the middle (`ffmpeg -ss MID -t 60`). The cut transcribes fine → loop lock (apply VAD below). The cut is also garbage → the audio itself is the problem (noise, distortion, wrong channel).

Mitigations:

- **VAD is the root-cause fix** and also roughly 2× faster on speech-heavy files: add `--vad -vm ~/.local/share/whisper/ggml-silero-v5.1.2.bin`. The silero model is **not** bundled with the system models — download once (864 KB):
  ```bash
  mkdir -p ~/.local/share/whisper && curl -fL -o ~/.local/share/whisper/ggml-silero-v5.1.2.bin \
    "https://huggingface.co/ggml-org/whisper-vad/resolve/main/ggml-silero-v5.1.2.bin"
  ```
- **VAD caveat — very quiet channels:** on a channel averaging around −50 dB (a far-end speaker with echo cancellation), silero merges everything into a handful of giant windows and whisper-cli emits one near-empty segment per window (observed: 6 segments for 100 minutes). VAD is useless there.
- **Do NOT "fix" a quiet channel by amplifying the WAV.** Raising the signal also raises the noise floor into speech-detection range and makes hallucination dramatically worse (observed: a ×477-segment loop after +12 dB gain on a channel that previously had only bounded runs). For quiet channels, run whisper *without* VAD at original levels — it handles quiet-but-clean audio decently — and strip duplicate runs in post.
- **Recovering a looped region:** isolate it (`ffmpeg -ss START -t LEN` + step-3 flags) and transcribe the cut alone — processing the region in isolation breaks the loop (a tail that looped for 90 s in the full run transcribed cleanly as a cut). Splice the recovered text back.

### 5. Poll for completion (background jobs)

Poll periodically, using sleep via `eca__bg_job` (60–120 s intervals), and `read_output` to see whisper's stderr progress. The job is done when the process has exited and the output `.txt`/`.srt` exists with nonzero size — the log's final `whisper_print_timings` block is the usual completion signature. If the log ends with a Vulkan out-of-memory or device-lost error instead, apply the `-ng` fallback from step 4.

### 6. Verify coverage (when completeness matters)

large-v2 occasionally **drops whole passages** — a 25-second stretch of real speech was observed missing from a 2-minute transcript. For casual gist requests you can skip this check; for anything the user will rely on (meeting minutes, decisions, records), verify. Windowing needs timestamps in both outputs, so run both passes with `-oj` and compare JSON segment offsets:

1. Run a second, cheap pass with the base model: roughly 20× real-time, so it costs little even for long recordings.
2. Compare the two outputs in ~30-second windows (bucket segments by `offsets.from`, compare character counts). A window where large-v2 produced little or no text but base produced substantial text is a suspected drop. (Large-v2 producing *more* text than base in a window is normal — it's the more accurate model.)
3. Caveat: on silence-heavy or noisy sources base hallucinates the same way large-v2 does, so the comparison degenerates (both sides garbage). There the 4b duplicate-scan plus the mid-file cut test are the reliable checks; trust those instead.
3. To recover a dropped region: cut it out (`ffmpeg -ss START -t LEN` with the same conversion flags as step 3), re-run large-v2 on the cut, and splice the recovered text into the transcript at the right place.

This same targeted-cut technique also settles disputed words: re-transcribe a few seconds around an ambiguous word and compare readings — but weigh the result against domain context, since whisper can consistently mis-hear jargon (e.g. Clojure as "closure"). When a word stays ambiguous, keep the more plausible reading and annotate the alternative in the transcript rather than silently guessing.

### 7. Post-process into a transcript file

Whisper's raw `.txt` is one unbroken block of text (timestamps live in the JSON from `-oj`). Turn it into `BASE_transcript.md` next to the source:

1. Read the `.txt` in chunks (`eca__read_file` with `limit`) — an hour of speech is ~8–10k words; for very long transcripts consider a subagent for this step so your own context isn't consumed.
2. Split into paragraphs at natural boundaries: topic shifts, speaker changes, question→answer transitions (long timestamp gaps are a useful hint). In dialogues, format speaker turns as Markdown blockquotes or with an em dash (`—`) at the start of each turn. Use the speaker count from step 1 to keep labels consistent (use names if the user gave them, otherwise `Speaker 1` / `Speaker 2` / …); if the count wasn't established, infer it from the content and note the assumption in the transcript header.
3. Write the `.md` with a top-level heading (source name, plus date if known), readable paragraphs, and **no timestamps** — strip the `[hh:mm:ss.mmm --> ...]` prefixes. Flag probable mis-hearings inline (`"closure"` → Clojure) — the user knows the context and can spot what whisper got wrong.
4. Once the `.md` is written, the raw `.txt`/`.json` have served their purpose — they are deleted in step 9.

### 8. Summarize — the final result

Once the transcript file is written, read it and produce a summary in chat. This summary is what the user asked for; end your reply with it (and mention the transcript file path). Adapt the shape to the content:

- **Meetings/standups** — decisions made, action items (with owners and deadlines when stated), key discussion points, open questions.
- **Lectures/talks** — main thesis and the key takeaways.
- **Interviews** — topics covered and notable answers.
- **Voice notes** — the gist and any tasks mentioned.

Scale length to content: a 2-minute voice note gets a couple of sentences; an hour-long meeting gets a structured breakdown. Quote exact wording only where precision matters (decisions, action items, numbers). Write the summary in the language the user is conversing in, regardless of the recording's language.

A summary is disposable; if the user wants the meeting's content kept — notes, a knowledge base, action items, "who said what" — the `meeting-knowledge-extractor` skill turns `BASE_transcript.md` into one Markdown note per fact (date, source person, tags, quote) in an OKF bundle with an index and a log. Offer it after the summary for meetings, handovers and onboarding calls, and use it when the user asks for notes or knowledge rather than a summary. The transcript header this workflow writes (source file, date, speaker roles) is what that skill reads first, so keep it accurate.

### 9. Clean up — always

The only files this workflow may leave behind are `BASE_transcript.md` (plus `BASE.srt` if the user asked for subtitles). Delete every intermediate — do this after every job, without asking:

- temp WAVs: `/tmp/BASE_mono.wav`, per-channel WAVs, region cuts;
- raw whisper output: `.txt`, `.json` (large-v2 and base passes, per-channel runs, cut re-runs);
- any raw output that ended up in the source directory anyway (e.g. a job run with the old `-of` convention) — check with `ls` and remove it.

## Advanced: one speaker per stereo channel

Some setups (e.g. call recorders) capture each speaker on a separate channel. If step 1 established there are exactly two speakers and the source is stereo with one speaker per channel, offer this technique when the user wants speaker labels: extract each channel with the `pan` filter — `-af "pan=mono|c0=c0"` for the left channel, `-af "pan=mono|c0=c1"` for the right (plus the same conversion flags as step 3; note `-map_channel` no longer exists in ffmpeg 7+), transcribe each **sequentially**, then merge the two JSONs chronologically by `offsets.from`, label the speakers, and strip timestamps from the final output. This doubles total transcription time — only do it on request.

Channel asymmetry is normal and drives decisions:

- Run `volumedetect` on each WAV: one channel is often the loud main talker (mean ≈ −20 dB, no silences) and the other a quiet backchanneler (mean ≈ −50 dB, frequent long silences). The loud channel is the content channel — VAD works great on it; the quiet channel is the one where VAD collapses and the 4b no-VAD + dedup path applies.
- Apply the 4b duplicate-scan to **each channel's output before merging** — a loop locked inside one channel will otherwise leak into the merged transcript.
- In the merged dialogue, drop turns that consist only of backchannel tokens (угу/ага/да/мм/ок) — the quiet speaker generates hundreds of them, and they bury the content. Note the assumption and speaker roles in the transcript header.
