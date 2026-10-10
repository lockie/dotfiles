# triz-engineering-solver

A Claude / AI-agent skill for solving engineering problems with Altshuller's **TRIZ** (Theory of Inventive Problem Solving). Replaces compromise-driven brainstorming with algorithmic problem solving over a corpus of patent-derived patterns.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## What it does

Given an engineering contradiction — *"improving X makes Y worse"* or *"this part must be both A and not-A"* — the skill produces **3–5 concrete inventive concepts** with explicit ideality scores rather than compromise solutions. It uses:

- **Ideal Final Result (IFR)** framing
- The **39 engineering parameters** and **40 inventive principles** distilled by Altshuller from ~200,000 patents
- The full **39×39 Contradiction Matrix** (1190 populated cells, anchor-verified against Altshuller 1985)
- **Su-Field analysis** with the canonical **76 Standard Solutions** (5-class taxonomy, Su-Field algebra notation)
- **Separation principles** (space / time / condition / system-level) for physical contradictions
- **ARIZ-85C** deep procedure when the quick pass fails the ideality bar
- The **8 trends of engineering system evolution** for roadmapping questions

## When to use

- Engineering trade-offs where improving parameter A degrades parameter B (technical contradiction)
- A single element must exhibit opposite properties (physical contradiction)
- Design bottleneck where conventional optimisation has plateaued
- System redesign aimed at the Ideal Final Result

## When NOT to use

- Pure software architecture without a physical analogue
- UX / interaction design
- Business or organisational strategy
- Open brainstorming with no concrete contradiction identified

The skill **refuses with reframe** when invoked on out-of-scope problems — see `examples/anti_example_misframed.md`.

## Install

For Claude Code:

```bash
git clone https://github.com/Antropocosmist/triz-engineering-solver \
  ~/.claude/skills/triz-engineering-solver
```

For other agent runtimes (Anthropic SDK, OpenAI Assistants, LangGraph, custom): point the agent's system prompt or tool router at `SKILL.md` and grant filesystem read access to this directory.

## Repo layout

```
.
├── README.md
├── LICENSE                          MIT
├── CONTRIBUTING.md                  anchor-cell verification protocol, style rules
├── SKILL.md                         entry point — workflow, triggers, output template
├── resources/                       lazily-loaded reference data
│   ├── 39_parameters.md
│   ├── 40_principles.md
│   ├── 76_standard_solutions.md     full 5-class taxonomy with Su-Field algebra
│   ├── contradiction_matrix.json    full 39×39 Altshuller matrix (1190 cells)
│   ├── separation_principles.md     decision procedure for physical contradictions
│   ├── ariz_85c.md                  9-part deep-analysis procedure
│   ├── evolution_trends.md          8 trends + S-curve framing
│   ├── glossary.md
│   └── output_template.md           machine-readable output template (use verbatim)
└── examples/
    ├── brake_disc.md                mechanical / thermal contradiction
    ├── battery_pack.md              physical contradiction via separation
    ├── heat_exchanger_fouling.md    process-industry contradiction + ideality drop
    └── anti_example_misframed.md    refuse-with-reframe demo
```

## Design properties

- **Deterministic where possible.** Decision points are reduced to lookups in structured resources, not free-form reasoning.
- **Source-anchored.** Every claim, value, or principle traces back to a primary source. Contributions to the contradiction matrix must pass a 5-cell anchor verification protocol (see `CONTRIBUTING.md`).
- **Refuse-with-reframe.** Out-of-scope problems are rejected explicitly, with a hint at where the user should go instead.
- **No compromise.** Concepts with `ideality ≤ 1` are dropped, not split-the-difference accepted. If no concept clears the bar, the skill escalates to ARIZ-85C rather than weaken the recommendation.

## Status

**v1.0 — release-ready.** Full Altshuller 39×39 matrix (1190 cells, 5/5 anchors verified). Three worked examples + one anti-example. Su-Field analysis with the full 76 Standard Solutions. ARIZ-85C deep procedure. 8 evolution trends. Workflow documented end-to-end.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Examples from non-mechanical domains (electronics, chemical engineering, optics, biotech) are particularly welcome.

## Attribution

- **TRIZ methodology**: Genrich Altshuller (1926–1998), originator. Primary sources: *Creativity as an Exact Science* (1979/1984), *The Innovation Algorithm* (1999). Modern reference: Darrell Mann, *Hands-On Systematic Innovation* (2002). Su-Field analysis: Yuri Salamatov, *TRIZ: The Right Solution at the Right Time* (1999).
- **Contradiction matrix data**: imported from the MIT-licensed [`kamil-szczepanik/TRIZ-Agents`](https://github.com/kamil-szczepanik/TRIZ-Agents) repository (`data/tools_sources/triz_matrix.xls`, Casey Perno 2007 transcription of Altshuller 1985). Cite the accompanying ICAART 2025 paper if you build on their work: *Szczepanik et al., "TRIZ Agents: A Multi-Agent LLM Approach for TRIZ-Based Innovation," 2025* — [arXiv:2506.18783](https://arxiv.org/abs/2506.18783).

## License

MIT — see [LICENSE](LICENSE).

## Authors

- [Antropocosmist](https://github.com/Antropocosmist)
- Claude
