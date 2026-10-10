---
name: meeting-knowledge-extractor
description: Extract the facts from meeting transcripts (current state of affairs, plans, decisions, action items, tasks, problems, open questions, how-tos, definitions, opinions) into an Open Knowledge Format (OKF) bundle - one short Markdown note per fact with YAML frontmatter (type, title, description, date, source person, tags, resource), a verbatim quote, an index.md grouped by topic and a log.md of meetings, all in English. Use this skill whenever the user wants to turn transcripts of meetings, calls, onboarding or handover sessions, standups, syncs, interviews or demos into notes, a knowledge base, an OKF bundle, an Obsidian or Zettelkasten vault, an action-item list, or a record of who said what and when - even if they only say "go through these transcripts and pull out the useful stuff" or "make notes from my onboarding calls". Not for transcribing audio itself; transcribe first, then use this.
---

# Meeting Knowledge Extractor

Turn meeting transcripts into a knowledge bundle: one small Markdown note per fact, an `index.md` that groups the notes by topic, and a `log.md` that records which meeting produced which facts. Every note records what is known, when it was said (`date`), who said it (`source`) and what it is about (`tags`). With that, the user can find everything on a topic, see who to ask, and judge whether a statement is still current.

Why one note per fact: a meeting mixes dozens of unrelated facts. Separate notes can be searched, tagged, linked and superseded one by one, each with its own provenance. A later meeting adds a newer note that updates or supersedes the old one instead of history being silently rewritten.

The bundle follows the Open Knowledge Format v0.1 (markdown files with YAML frontmatter; `type` required; `index.md` and `log.md` reserved). If the `okf-open-knowledge-format` skill is installed, its `references/spec-v01.md` is the spec and its `scripts/validate.sh` checks conformance. The bundled script `SKILL_DIR/scripts/write_facts.py` (Python 3, stdlib only) writes the notes, the index and the log so that the format never depends on memory; `SKILL_DIR` is the directory containing this file.

## Inputs

- **Transcripts** in any text form (Markdown, plain text, SRT/VTT, chat export). Given only a recording, transcribe it first, then continue here.
- **Output directory** - the bundle. If the user didn't name one, use `knowledge/` next to the transcripts and say so.
- **Hints** the user may give: who the speakers are, the meeting date, a focus ("just the action items").

## Workflow

### 1. Pin down the meeting's metadata

Every note inherits these, so settle them per transcript before extracting.

**Date.** The day the meeting took place, `YYYY-MM-DD`. Use the first source that has it:

1. the user;
2. the transcript's header or metadata;
3. a date in the transcript's or the recording's file name (`standup-20260310.mkv`);
4. an explicit date in the conversation ("today, the 10th...");
5. the modification time of the original recording - look for a media file with the same base name next to the transcript. Recorders finish writing the file when the meeting ends, so its mtime is normally the meeting day;
6. the transcript's own modification time - last resort, since transcription often runs hours or days later.

Sources 5-6 are guesses: name the source in your final report so the user can correct it.

**People.** Attribution is half of what the user wants, and a wrong attribution misleads more than a missing one, so map the transcript's speaker labels to people before extracting. Evidence, strongest first: the user's hints; the transcript header; self-introductions ("I'm Maria, I run the platform team"); how participants address each other; roles visible in the talk (who explains, who asks).

The `source` of a note is written as `Name (role)`, e.g. `Maria Lopez (platform team lead)`, or as the role alone, e.g. `Departing backend engineer`, when the name is unknown. Never write `Speaker 1` or a similar label: it means nothing a week later. When a speaker's name doesn't appear anywhere, ask the user for it - one question covering all transcripts of the session, before extracting. If you can't ask (no user in the loop) or get no answer, use the role and list the open names in your report.

Unlabeled transcripts (turns marked only with dashes, or one block of text): attribute each fact by content - the person explaining a system is usually its source, the person asking usually isn't. When it's genuinely unclear, choose the likelier person and append `(inferred)` to the source.

**Meeting name.** A short kebab-case name from the file name, without suffixes like `_transcript`: `weekly-sync_transcript.md` → `weekly-sync`. It appears in the log and in citations.

**Language.** Notes, titles, tags and index entries are always in English, whatever language the meeting or the user's request is in. Only the verbatim quotes stay in the original language - they are evidence, and translation loses the exact wording. Identifiers, commands, product and table names stay as they are.

### 2. Check what the bundle already has

```bash
python3 SKILL_DIR/scripts/write_facts.py OUT_DIR
```

With no facts file, the script lists the meetings already logged, the index sections and the tags in use, with counts. Then read `index.md` - it's the map of the bundle.

- **Reuse the existing tags** wherever they fit. A bundle that has `billing`, `billing-service` and `invoices` for the same thing can't be searched reliably; one vocabulary across meetings is what makes "everything on X" work. The first tag of a note decides its section in the index, so pick it with the index in mind.
- **Same meeting already logged?** Ask the user before replacing its notes - they may have edited them. No answer means don't replace.
- **Related notes?** Open the ones on the subjects the new meeting touches. If the new meeting changes, completes or cancels what an older note says, the new note must say so through `updates`, `supersedes` or `cancels` (step 3) - that is how the bundle stays current without rewriting history.

### 3. Read the whole transcript and extract the facts

Read all of it, in chunks if it's long. Don't skim or sample: handovers and onboarding calls hide important facts in asides ("by the way, staging shares its database with QA"). Make sure you see whole lines - transcripts often keep a long monologue on one line, and some file viewers cut long lines short; if yours does, read in raw mode or wrap the file first. Collect candidates as you go, then consolidate at the end - speakers often refine or correct a statement later in the call, and the note should carry the final version.

**A fact** is one self-contained unit of knowledge someone would want to look up later. Test: could a colleague who missed the meeting understand and use the note without the transcript? If it only makes sense next to another note, add the missing context; if it covers two unrelated things, split it. Extraction is not summarization: a summary keeps the gist and drops the specifics, and the specifics - a table name, who owns a service, the flag that skips a slow step - are what people come back for.

Before writing, look at the whole set: merge candidates that state the same fact, and check the first tags - each index section should end up with several notes, so fold near-synonyms into one broad area (`ci`, `testing`, `dev-environment` are one `testing` section unless the bundle already separates them).

**Types** (`type`). Use these where they fit; when none does, a short descriptive kebab-case type of your own is fine.

| type | captures | example description |
|---|---|---|
| `current-state` | how things are now: systems, processes, responsibilities, and the history that explains them | "Invoices are generated by a nightly cron job in the billing service." |
| `plan` | intended changes, roadmaps, timelines, expected events | "Staging moves to the new cluster by the end of March." |
| `decision` | something agreed or chosen, with the reason | "The new service uses PostgreSQL, not MongoDB, to keep one database stack." |
| `action-item` | a follow-up someone takes on because of this meeting - set `owner`, and `due` when known | "Request VPN access from IT by 2026-03-13." |
| `task` | a work item in the team's backlog or in progress: who is on it, its state | "Den is splitting the field screen into several screens." |
| `problem` | known issues, risks, tech debt, pain points | "Report export times out for accounts with 10k+ rows." |
| `open-question` | unknowns and unresolved questions, with who might answer | "Unclear who will own the mobile app after the reorg." |
| `how-to` | procedures, commands, steps | "Regenerate the API client with `make codegen` after changing the schema." |
| `definition` | jargon, abbreviations, domain terms | "ARR is annual recurring revenue as the finance dashboard counts it." |
| `opinion` | a personal judgement or preference, not an established fact - the source matters most here | "Maria thinks feature flags should live on the subscription, not the workspace." |

In onboarding and handover calls, many action items are implicit: "have a look at the billing tables", "ask Maria how the export works". Record them as `action-item` with the newcomer as `owner` - that's the checklist the user will want.

**Fields of a fact:**

- `file` - the subject of the note as a short kebab-case slug of one to four words: `ci-pipelines`, `planet-subscription-api`, `logo-priority`. It becomes the file name (`ci-pipelines.md`; a numeric suffix is added if the name is taken), so it should read well in a directory listing.
- `title` - a short label of up to eight words, like a headline: "CI pipelines fail on first MR", "Logo selection order". It is the note's heading and its link text in the index and log.
- `description` - the fact itself in one plain sentence of at most about 30 words (the script rejects more than 40), with the key specifics: "Andrey's first merge request will have failing pipelines because he lacks registry access; the team grants it then." Index entries show it, so it must stand alone; everything else goes into the body.
- `body` - optional details beyond the description: context (why, who is involved), then bullets for specifics if there are any. Keep specifics exact: names, numbers, versions, commands, paths, table and field names, URLs. Don't repeat the description; omit the body when there is nothing to add.
  - Resolve relative dates against the meeting date, keeping the original words: in a meeting on Tuesday 2026-03-10, "by next Friday" → "by 2026-03-13 ("by next Friday")". Put a resolved deadline in `due`.
  - Keep the speaker's certainty. "I think the cron runs at night", "nobody knows yet", "maybe next sprint" stay hedged in the note. A guess recorded as a fact is the most damaging error a knowledge base can hold.
  - Speech recognition mishears, and transcripts often flag it in brackets. Write the corrected term; if the correction is itself a guess, say so briefly ("ASR: 'cell force', probably Salesforce").
- `quote` - a short verbatim excerpt (one to three sentences) backing the fact, in the transcript's language. Include one for decisions, plans, action items, numbers and anything surprising; it lets the user verify the note without reopening the transcript.
- `tags` - the topics, two to five lowercase hyphenated English words matching how the user will search. Existing tags first. The first tag is the note's section in the index, so make it a broad area the bundle will keep collecting notes under - a product area, system or process such as `billing`, `access`, `testing`, `vra-maps` - and aim for a dozen or so sections with several notes each rather than one heading per note; the later tags carry the specifics (`stripe-migration`, `pg-restore`). On notes about who is responsible for what, a shared tag like `who-to-ask` pays off.
- `source` - the person whose statement the fact comes from, as described in step 1. In Q&A, that's whoever answers; if the newcomer paraphrases and the expert confirms, it's the expert. People merely mentioned ("Tom wrote the export service") go into the description or body, not into `source`.
- `resource` - a URI for the asset the fact is about, when it has one: a URL that was named or shown (a dashboard, a Notion page, a repository, an API endpoint, a ticket). Most facts have none; omit it then.
- `owner`, `due` - for action items, tasks and plans: who does it, and the ISO date if one is stated or resolvable.
- `timecode` - the nearest timestamp at or before the statement, as the transcript shows it (`"10:29"`, `"1:02:15"`), when the transcript has timestamps. It goes into the note's citation so the user can jump to that moment.
- `updates`, `supersedes`, `cancels` - file names of existing notes this fact relates to. `updates`: the old note stays valid but this one adds to or partly changes it. `supersedes`: the old statement is no longer true (a state changed, a plan was replaced). `cancels`: a plan, task or action item was dropped. The script links the notes both ways, marks superseded and cancelled notes (`status`, `superseded_by`) and takes them out of the index; don't write those links into the body yourself.

**Leave out** greetings, "can you see my screen", scheduling chatter, jokes and thinking-aloud navigation ("where was it... here") - unless they carry information. When unsure whether a specific fact deserves a note, keep it: a note nobody reads costs little, a missing one sends the user back to a two-hour recording.

**Never copy secrets** - passwords, tokens, API keys, one-time codes - into a note, even when someone reads them out on the call, and not inside the verbatim quote either: pick another excerpt or replace the secret with `[...]`. Notes get synced, shared and fed to other tools, where a plain-text credential is a leak. Record that the secret exists and how to get it instead: "The staging DB password is in the team vault; ask Maria for access".

### 4. Write the notes

Put the facts of one transcript into a JSON file outside the bundle (for instance in the system temp dir), then run:

```bash
python3 SKILL_DIR/scripts/write_facts.py OUT_DIR /tmp/facts-weekly-sync.json
```

The script validates the facts, writes one `.md` per fact, adds each to `index.md` under its first tag (creating the index if needed), prepends a dated entry to `log.md` listing the meeting and its facts, applies `updates`/`supersedes`/`cancels`, and refuses to touch a meeting that is already logged unless you add `--replace` (only with the user's consent; it then removes that meeting's notes, restores whatever they had superseded, and writes the new ones). If it reports errors, fix the JSON and rerun; nothing is written until the whole input is valid. For a long meeting you may split the facts across several JSON files with the same header and pass them all in one run, in meeting order.

```json
{
  "meeting": "weekly-sync",
  "date": "2026-03-10",
  "transcript": "/home/me/meetings/weekly-sync_transcript.md",
  "facts": [
    {
      "file": "staging-cluster",
      "type": "plan",
      "title": "Staging moves to new cluster",
      "description": "Staging is switched to the new Kubernetes cluster before the end of March 2026; production follows in Q2, no date yet.",
      "source": "Maria Lopez (platform team lead)",
      "tags": ["staging", "kubernetes", "infrastructure"],
      "due": "2026-03-31",
      "timecode": "12:40",
      "body": "The old cluster stays up for production until Q2 (\"prod waits until Q2\").",
      "quote": "We'll move staging over before the end of the month, prod waits until Q2."
    }
  ]
}
```

Each fact needs `file`, `type`, `title`, `description`, `source` and `tags`. Optional: `body`, `quote` (a string or a list), `resource`, `owner`, `due`, `timecode`, `date` (overrides the meeting date), `updates`, `supersedes`, `cancels`, and any other field you find useful (`status`, `customer`, ...) - extra fields go into the frontmatter as they are. List the facts in the order they first come up in the meeting. `transcript` is optional but valuable: it becomes the citation link in every note and in the log.

The fact above becomes `staging-cluster.md`:

```markdown
---
type: plan
title: Staging moves to new cluster
description: Staging is switched to the new Kubernetes cluster before the end of March 2026; production follows in Q2, no date yet.
date: 2026-03-10
source: Maria Lopez (platform team lead)
tags: [staging, kubernetes, infrastructure]
due: 2026-03-31
---

# Staging moves to new cluster

Staging is switched to the new Kubernetes cluster before the end of March 2026; production follows in Q2, no date yet.

The old cluster stays up for production until Q2 ("prod waits until Q2").

> We'll move staging over before the end of the month, prod waits until Q2.

# Citations

[1] [weekly-sync transcript, 12:40](../weekly-sync_transcript.md)
```

and `index.md` gets, under `# staging`, the line `- [Staging moves to new cluster](./staging-cluster.md) - Staging is switched to ...`; `log.md` gets, under today's date, `- **Creation**: N facts from meeting *weekly-sync* (2026-03-10), transcript [...]` with one nested line per fact.

### 5. Report back

Close with a short report:

- where the bundle is, how many notes of each type, and which existing notes were updated, superseded or cancelled;
- the action items, the user's own first, with owners and due dates;
- what the user should double-check: a date taken from file times, names you inferred or couldn't get, garbled passages a note relies on.

## Several transcripts

Handle them one at a time - metadata, extraction, writing - in chronological order, and rerun the inventory before each one, so tags stay consistent and later meetings can update or supersede notes from earlier ones.

## Changes over time

The notes are a dated record of what was said, not wiki pages to keep rewriting. When a later meeting changes the picture, write a new note and relate it to the old one with `updates`, `supersedes` or `cancels`; the old note keeps its text and date, gains a `status` and a `superseded_by` pointer when it is no longer current, and drops out of the index while staying in the log. Readers of the index see the current state; readers of the log see how it got there.
