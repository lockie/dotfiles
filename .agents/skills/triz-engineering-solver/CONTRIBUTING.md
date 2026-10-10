# Contributing

Thanks for considering a contribution to `triz-engineering-solver`. This skill is consumed by AI agents, so the bar is correctness and verifiability, not stylistic polish.

## Ground rules

1. **Every claim must be sourceable.** If you change the matrix, the principles, the Standard Solutions, or any reference data, the new value must trace back to a primary source (book, paper, recognised community resource). LLM-generated content masquerading as canonical reference data will be rejected.
2. **The skill is markdown-first.** A skill is consumed by an AI agent reading `SKILL.md` and lazily loading `resources/`. Code is allowed only when it gives the agent a capability that a markdown reference cannot.
3. **Examples are deliverables.** Each new worked example must follow the format of `examples/brake_disc.md` or `examples/heat_exchanger_fouling.md`: IFR, contradiction classification, matrix lookup (with `Source:` annotations), Su-Field, resource enumeration, 3–5 concepts with ideality scores, summary table, recommendation.
4. **Don't pad.** Three excellent examples beat ten shallow ones.

## Anchor-cell verification protocol (matrix contributions)

The classic 39×39 Altshuller contradiction matrix is widely paraphrased online, but most freely available copies are LLM-generated or incomplete. **Any matrix replacement / merge must satisfy the following anchor cells**:

```
(1, 3)  ⊇ {15, 8, 29, 34}
(1, 9)  ⊇ {2, 8, 15, 38}
(1, 14) ⊇ {28, 27, 18, 40}
(1, 27) ⊇ {3, 11, 1, 27}
(14, 1) ⊇ {1, 8, 40, 15}
```

**Match by set, not by order.** Multiple authoritative transcriptions (Altshuller 1985, Mann 2003, Salamatov 1999, Casey Perno 2007 XLS) reorder the same principle set for the same cell — different sources rank by ID, by Altshuller's suggested priority, or by frequency-in-patent-database. Reordering is normal; missing principles are not.

If a candidate dataset disagrees on the *set* for any anchor cell, **reject it**.

When submitting a replacement matrix:
- Include the source citation in `resources/contradiction_matrix.json` under `meta.primary_source`.
- Run the anchor check before opening a PR.
- For cells whose source is uncertain, omit them entirely (the agent falls back to reasoning over the 40 principles) — never guess.

## Adding a worked example

Worked examples teach the skill's workflow by demonstration and are how new users (and future agents) calibrate to what good TRIZ output looks like. Domains most wanted:

- Electronics / electrical engineering
- Chemical engineering and process design
- Optics and photonics
- Biotech / medical devices
- Software-with-physical-substrate (robotics, embedded, controls)

Format: copy `examples/brake_disc.md` or `examples/heat_exchanger_fouling.md` and follow it section-for-section. Each concept must:
- Name the inventive principle(s) by number + name
- Mark `Source: matrix` or `Source: inferred` or `Source: standard-solution-<class.subclass>` or `Source: separation-<axis>`
- Enumerate the resource it consumes
- Quantify (or band) an ideality score
- Surface at least one open validation risk

Concepts with `ideality ≤ 1` must be **dropped**, not compromised. Demonstrate the drop rule explicitly when applicable.

## Style

- Markdown only for docs. Use fenced code blocks with language identifiers.
- One blank line between paragraphs; no trailing whitespace.
- Cite sources inline with `Source:` markers in deliverables.
- Avoid emojis — engineering deliverable, not marketing copy.
