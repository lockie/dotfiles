#!/usr/bin/env python3
"""Write facts extracted from a meeting into an OKF bundle: one note per fact, plus index.md and log.md.

  write_facts.py OUT_DIR                       inventory: meetings logged, index sections, tags in use
  write_facts.py OUT_DIR FACTS.json [...]      write notes, update index.md and log.md
  write_facts.py OUT_DIR FACTS.json --replace  remove this meeting's earlier notes first, then write

Several FACTS.json files of one meeting are concatenated in the given order.
Nothing is written unless the whole input is valid. Stdlib only; the input format is described in SKILL.md.
"""
import argparse
import datetime
import json
import os
import re
import sys
from collections import Counter
from pathlib import Path

REQUIRED = ("file", "type", "title", "description", "source", "tags")
RELATIONS = ("updates", "supersedes", "cancels")
FIELD_ORDER = ("type", "title", "description", "resource", "date", "source", "tags", "owner", "due")
NOT_FRONTMATTER = {"file", "body", "quote", "timecode", *RELATIONS}
RESERVED = {"index.md", "log.md"}
ISO_DATE = re.compile(r"\d{4}-\d{2}-\d{2}")
FIELD_NAME = re.compile(r"[A-Za-z][A-Za-z0-9_-]*")
YAML_WORDS = {"y", "n", "yes", "no", "on", "off", "true", "false", "null"}
HEADING = re.compile(r"^(#{1,3})\s+(.+?)\s*$")
LINK = re.compile(r"\[([^\]]*)\]\(([^)\s]+)\)")
BULLET = re.compile(r"^\s*[-*]\s+")
MEETING_ENTRY = re.compile(r"^- \*\*Creation\*\*: \d+ facts? from meeting \*(.+?)\* \((\d{4}-\d{2}-\d{2})")


# ---------- small helpers ----------

def slugify(text, limit=60):
    slug = re.sub(r"[\W_]+", "-", str(text).lower()).strip("-")
    if len(slug) > limit:
        slug = slug[:limit].rsplit("-", 1)[0]
    return slug or "note"


def normalize_tag(tag):
    tag = re.sub(r"[^\w/]|_", "-", str(tag).strip().lstrip("#").lower())
    return re.sub(r"-{2,}", "-", tag).strip("-/")


def yaml_value(key, value):
    """Bare YAML where it is unambiguous (tags, dates, plain titles), JSON-quoted otherwise."""
    if isinstance(value, list):
        items = [str(v) for v in value]
        if all(re.fullmatch(r"[\w./-]+", i) for i in items):
            return "[" + ", ".join(items) + "]"
        return json.dumps(value, ensure_ascii=False)
    if value is None or isinstance(value, (bool, int, float, dict)):
        return json.dumps(value, ensure_ascii=False)
    s = str(value)
    if key in ("date", "due") and ISO_DATE.fullmatch(s):
        return s
    plain = (s == s.strip() and ": " not in s and " #" not in s and not s.endswith(":") and s.lower() not in YAML_WORDS
             and (s[:1].isalpha() or re.fullmatch(r"[\w./-]+", s) is not None and s[:1] != "-"))
    return s if plain else json.dumps(s, ensure_ascii=False)


def unquote(s):
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in "\"'":
        try:
            return json.loads(s) if s[0] == '"' else s[1:-1]
        except ValueError:
            return s[1:-1]
    return s


def read_frontmatter(path):
    """Tiny reader for the notes this script writes (plus light hand edits): {key: str | list}."""
    fm, key = {}, None
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    if not lines or lines[0].strip() != "---":
        return fm
    for line in lines[1:]:
        if line.strip() == "---":
            break
        item = re.match(r"\s+-\s+(.*)", line)
        if item and key and isinstance(fm.get(key), list):
            fm[key].append(unquote(item.group(1)))
            continue
        m = re.match(r"([A-Za-z][\w-]*):\s*(.*)", line)
        if not m:
            continue
        key, raw = m.group(1), m.group(2).strip()
        if raw.startswith("[") and raw.endswith("]"):
            fm[key] = [unquote(x) for x in raw[1:-1].split(",") if x.strip()]
        else:
            fm[key] = [] if raw == "" else unquote(raw)
    return fm


def set_frontmatter(path, **fields):
    """Set (value) or remove (None) top-level frontmatter keys; the body is untouched."""
    text = path.read_text(encoding="utf-8")
    m = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not m:
        return
    keep = [l for l in m.group(1).splitlines() if not (l[:1].isalpha() and l.split(":")[0] in fields)]
    keep += [f"{k}: {yaml_value(k, v)}" for k, v in fields.items() if v is not None]
    path.write_text("---\n" + "\n".join(keep) + "\n---\n" + text[m.end():], encoding="utf-8")


def notes_in(out):
    return sorted(p for p in out.glob("*.md") if p.name not in RESERVED)


def read_lines(path):
    return path.read_text(encoding="utf-8").splitlines() if path.exists() else []


def tidy(lines):
    """Collapse blank runs, drop leading blanks, one trailing newline."""
    result = []
    for line in lines:
        if line.strip() == "" and (not result or result[-1] == ""):
            continue
        result.append(line.rstrip())
    while result and result[-1] == "":
        result.pop()
    return "\n".join(result) + "\n"


def link_name(target):
    return Path(target.split("#")[0]).name


def title_of(out, name):
    return str(read_frontmatter(out / name).get("title") or Path(name).stem)


def relpath(target, out):
    return os.path.relpath(Path(target).resolve(), out.resolve())


# ---------- index.md ----------

def heading_level(lines):
    """Level of the headings that hold entries (default 1, as in the OKF spec)."""
    levels = Counter()
    for i, line in enumerate(lines):
        m = HEADING.match(line)
        if m and any(BULLET.match(l) for l in lines[i + 1:i + 4]):
            levels[len(m.group(1))] += 1
    return levels.most_common(1)[0][0] if levels else 1


def section_bounds(lines, tag):
    for i, line in enumerate(lines):
        m = HEADING.match(line)
        if m and m.group(2).strip().lower() == tag.lower():
            end = next((j for j in range(i + 1, len(lines)) if HEADING.match(lines[j])), len(lines))
            return i, end
    return None


def index_add(lines, tag, entry):
    bounds = section_bounds(lines, tag)
    if bounds is None:
        lines += ["", f"{'#' * heading_level(lines)} {tag}", "", entry]
        return
    start, end = bounds
    bullets = [i for i in range(start + 1, end) if BULLET.match(lines[i])]
    if bullets:
        lines.insert(bullets[-1] + 1, entry)
    else:
        lines[start + 1:start + 1] = ["", entry]


def index_remove(lines, names):
    """Drop entries linking to the given files; drop sections that this leaves empty."""
    kept, touched = [], set()
    for line in lines:
        m = LINK.search(line)
        if BULLET.match(line) and m and link_name(m.group(2)) in names:
            touched.add(next((HEADING.match(k).group(2) for k in reversed(kept) if HEADING.match(k)), None))
            continue
        kept.append(line)
    drop = set()
    for i, line in enumerate(kept):
        m = HEADING.match(line)
        if m and m.group(2) in touched:
            end = next((j for j in range(i + 1, len(kept)) if HEADING.match(kept[j])), len(kept))
            if not any(BULLET.match(l) for l in kept[i:end]):
                drop.update(range(i, end))
    return [l for i, l in enumerate(kept) if i not in drop]


def index_entry(name, title, description):
    return f"- [{title}](./{name}) - {description}"


def new_index():
    return ["---", 'okf_version: "0.1"', "---"]


# ---------- log.md ----------

def log_find(lines, meeting, date):
    return next((i for i, l in enumerate(lines) if (m := MEETING_ENTRY.match(l)) and m.groups() == (meeting, date)), None)


def log_remove(lines, meeting, date):
    """Remove the meeting's entry (with its nested facts); return the remaining lines and the files it listed."""
    at = log_find(lines, meeting, date)
    if at is None:
        return lines, []
    end = at + 1
    while end < len(lines) and lines[end].startswith("  "):
        end += 1
    files = [link_name(m.group(2)) for l in lines[at + 1:end] if (m := LINK.search(l))]
    rest = lines[:at] + lines[end:]
    for i, line in enumerate(rest):  # drop a day heading left without entries
        if re.match(r"^## \d{4}-\d{2}-\d{2}\s*$", line):
            nxt = next((j for j in range(i + 1, len(rest)) if rest[j].startswith("#")), len(rest))
            if not any(l.strip() for l in rest[i + 1:nxt]):
                return rest[:i] + rest[nxt:], files
    return rest, files


def log_add(lines, block):
    today = datetime.date.today().isoformat()
    if not lines:
        lines += ["# Update Log"]
    at = next((i for i, l in enumerate(lines) if l.strip() == f"## {today}"), None)
    if at is None:
        at = next((i + 1 for i, l in enumerate(lines) if l.startswith("# ")), 0)
        lines[at:at] = ["", f"## {today}", ""]
        at += 1
    at += 1
    if at < len(lines) and lines[at].strip() == "":
        at += 1
    lines[at:at] = block  # newest first within the day, like the days themselves


# ---------- facts ----------

def load(paths):
    header, facts, errors = None, [], []
    for path in paths:
        try:
            data = json.loads(Path(path).read_text(encoding="utf-8"))
        except (OSError, ValueError) as e:
            errors.append(f"{path}: {e}")
            continue
        if not isinstance(data, dict):
            errors.append(f"{path}: top level must be an object")
            continue
        this = {k: str(data.get(k) or "").strip() for k in ("meeting", "date", "transcript")}
        if header is None:
            header = this
        elif this != header:
            errors.append(f"{path}: meeting/date/transcript differ from the first file")
        facts += data.get("facts") or []
    return header, facts, errors


def validate(header, facts):
    errors = [f"missing top-level '{k}'" for k in ("meeting", "date") if not header[k]]
    if header["date"] and not ISO_DATE.fullmatch(header["date"]):
        errors.append(f"date must be YYYY-MM-DD, got {header['date']!r}")
    if not facts:
        errors.append("no facts")
    for n, fact in enumerate(facts, 1):
        if not isinstance(fact, dict):
            errors.append(f"fact {n}: not an object")
            continue
        where = f"fact {n} ({str(fact.get('title', ''))[:40]!r})"
        errors += [f"{where}: missing '{k}'" for k in REQUIRED if not fact.get(k)]
        errors += [f"{where}: bad field name {k!r}" for k in fact if not FIELD_NAME.fullmatch(k)]
        if isinstance(fact.get("tags"), list):
            fact["tags"] = list(dict.fromkeys(t for t in map(normalize_tag, fact["tags"]) if t))
        elif "tags" in fact:
            errors.append(f"{where}: 'tags' must be a list")
        if fact.get("type"):
            fact["type"] = slugify(fact["type"])
        if fact.get("title"):
            fact["title"] = " ".join(str(fact["title"]).split())
            if len(fact["title"].split()) > 8:
                errors.append(f"{where}: title has {len(fact['title'].split())} words, keep it to 8 or fewer")
        if fact.get("description"):
            fact["description"] = " ".join(str(fact["description"]).split())
            if len(fact["description"].split()) > 40:
                errors.append(f"{where}: description has {len(fact['description'].split())} words, keep it to one sentence of about 30; move details to body")
        if fact.get("file"):
            fact["file"] = slugify(fact["file"], 40)
            if fact["file"].count("-") > 3:
                errors.append(f"{where}: file {fact['file']!r} has more than 4 words; name the subject only")
        if re.search(r"speaker|спикер", str(fact.get("source", "")), re.I):
            errors.append(f"{where}: source must name the person or their role, not 'Speaker N'")
        for k in ("date", "due"):
            if fact.get(k) and not ISO_DATE.fullmatch(str(fact[k])):
                errors.append(f"{where}: {k} must be YYYY-MM-DD")
        for k in RELATIONS:
            if k in fact and not isinstance(fact[k], list):
                errors.append(f"{where}: '{k}' must be a list of note file names")
    return errors


def assign_names(facts, taken):
    taken = set(taken) | RESERVED
    for fact in facts:
        name, n = f"{fact['file']}.md", 1
        while name in taken:
            n += 1
            name = f"{fact['file']}-{n}.md"
        taken.add(name)
        fact["_name"] = name


def render(fact, header, out):
    fields = {k: v for k, v in fact.items() if k not in NOT_FRONTMATTER and not k.startswith("_") and v not in (None, "", [], {})}
    fields.setdefault("date", header["date"])
    keys = [k for k in FIELD_ORDER if k in fields] + sorted(k for k in fields if k not in FIELD_ORDER)
    lines = ["---", *(f"{k}: {yaml_value(k, fields[k])}" for k in keys), "---", "",
             f"# {fact['title']}", "", str(fact["description"]).strip()]
    if fact.get("body"):
        lines += ["", str(fact["body"]).strip()]
    for rel in RELATIONS:
        for old in fact.get(rel) or []:
            lines += ["", f"{rel.capitalize()} [{title_of(out, old)}](./{old})."]
    quotes = fact.get("quote") or []
    for quote in [quotes] if isinstance(quotes, str) else quotes:
        lines += ["", *(f"> {l}".rstrip() for l in str(quote).strip().splitlines())]
    where = f", {fact['timecode']}" if fact.get("timecode") else ""
    if header["transcript"]:
        lines += ["", "# Citations", "", f"[1] [{header['meeting']} transcript{where}]({relpath(header['transcript'], out)})"]
    elif where:
        lines += ["", "# Citations", "", f"[1] {header['meeting']} transcript{where}"]
    return "\n".join(lines) + "\n"


def write(out, paths, replace):
    header, facts, errors = load(paths)
    if header:
        errors += validate(header, facts)
    if errors:
        print("Nothing written:", *errors, sep="\n  ", file=sys.stderr)
        return 1
    out.mkdir(parents=True, exist_ok=True)
    header["meeting"] = meeting = slugify(header["meeting"])
    index, log = read_lines(out / "index.md") or new_index(), read_lines(out / "log.md")
    removed = set()
    if log_find(log, meeting, header["date"]) is not None:
        if not replace:
            print(f"log.md already has an entry for meeting {meeting} on {header['date']}.\n"
                  "Rerun with --replace to remove those notes and write the new ones.", file=sys.stderr)
            return 2
        log, removed_names = log_remove(log, meeting, header["date"])
        removed = set(removed_names)
        index = index_remove(index, removed)
    patches = []  # frontmatter edits of existing notes, applied at commit
    for path in notes_in(out):  # notes a removed note had superseded become current again
        fm = read_frontmatter(path)
        if removed and link_name(str(fm.get("superseded_by", ""))) in removed:
            patches.append((path, dict(status=None, superseded_by=None)))
            index_add(index, (fm.get("tags") or ["untagged"])[0],
                      index_entry(path.name, fm.get("title") or path.stem, fm.get("description") or ""))
    existing = {p.name for p in notes_in(out)} - removed
    for n, fact in enumerate(facts, 1):
        for rel in RELATIONS:
            names = [link_name(o) for o in fact.get(rel) or []]
            fact[rel] = [o if o.endswith(".md") else o + ".md" for o in names]
            errors += [f"fact {n}: {rel} target {o!r} is not a note in {out}" for o in fact[rel] if o not in existing]
    if errors:
        print("Nothing written:", *errors, sep="\n  ", file=sys.stderr)
        return 1
    assign_names(facts, existing)
    notes, entries = [], []
    for fact in facts:
        name = fact["_name"]
        notes.append((out / name, render(fact, header, out)))
        index_add(index, fact["tags"][0], index_entry(name, fact["title"], fact["description"]))
        entry = f"  - [{fact['title']}](./{name}) - {fact['type']}"
        for rel in RELATIONS:
            for old in fact[rel]:
                entry += f"; {rel} [{title_of(out, old)}](./{old})"
                if rel != "updates":
                    patches.append((out / old, dict(status="superseded" if rel == "supersedes" else "cancelled",
                                                    superseded_by=f"./{name}")))
                    index = index_remove(index, {old})
        entries.append(entry)
    source = f", transcript [{Path(header['transcript']).name}]({relpath(header['transcript'], out)})" if header["transcript"] else ""
    log_add(log, [f"- **Creation**: {len(facts)} fact{'s' if len(facts) != 1 else ''} from meeting *{meeting}* ({header['date']}){source}", *entries])
    # commit
    for name in removed:
        (out / name).unlink(missing_ok=True)
    for path, text in notes:
        path.write_text(text, encoding="utf-8")
    for path, fields in patches:
        set_frontmatter(path, **fields)
    (out / "index.md").write_text(tidy(index), encoding="utf-8")
    (out / "log.md").write_text(tidy(log), encoding="utf-8")
    print(f"Wrote {len(facts)} notes to {out}; index.md and log.md updated" + (f"; replaced {len(removed)}" if removed else ""))
    print("types:", ", ".join(f"{k} {v}" for k, v in Counter(f["type"] for f in facts).most_common()))
    print("tags:", ", ".join(f"{k} {v}" for k, v in Counter(t for f in facts for t in f["tags"]).most_common()))
    return 0


def inventory(out):
    if not out.is_dir():
        print("no bundle yet: the directory does not exist")
        return 0
    meetings = [f"{m.group(1)} ({m.group(2)})" for l in read_lines(out / "log.md") if (m := MEETING_ENTRY.match(l))]
    print("meetings:", ", ".join(meetings) or "none")
    sections = [m.group(2) for l in read_lines(out / "index.md") if (m := HEADING.match(l))]
    print("index sections:", ", ".join(sections) or "none")
    tags, superseded, notes = Counter(), 0, notes_in(out)
    for path in notes:
        fm = read_frontmatter(path)
        tags.update(t for t in (fm.get("tags") or []) if isinstance(t, str))
        superseded += bool(fm.get("superseded_by"))
    print(f"notes: {len(notes)} ({superseded} superseded or cancelled)")
    print("tags:", ", ".join(f"{k} ({v})" for k, v in tags.most_common()) or "none")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("out_dir", type=Path)
    ap.add_argument("facts", nargs="*", help="facts JSON file(s) of one meeting, in meeting order")
    ap.add_argument("--replace", action="store_true", help="remove this meeting's earlier notes first")
    args = ap.parse_args()
    if not args.facts:
        return inventory(args.out_dir)
    return write(args.out_dir, args.facts, args.replace)


if __name__ == "__main__":
    sys.exit(main())
