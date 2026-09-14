# ARIZ-85C — Algorithm for Inventive Problem Solving

ARIZ ("Algorithm for Inventive Problem Solving") is the formal procedure invoked when the quick 40-principles pass produced no strong concept. The 1985 "C" revision is the canonical academic version. ARIZ converts a fuzzy engineering problem into a sharp **physical contradiction** localised in **space**, **time**, and **substance-field resources**, and then attacks it with the Standard Solutions.

ARIZ-85C contains **9 parts**, each with multiple sub-steps. This file abstracts each part to its operational essence; for verbatim text see Altshuller (1985) or Salamatov (1999).

## Part 1 — Analyse the problem

1.1 Convert the raw problem into a **mini-problem**: "All elements of the system remain unchanged or simplify, but the required result is achieved by itself."
1.2 Name the **conflicting pair**: the *product* (what is acted upon) and the *tool* (what acts).
1.3 Formulate the two **technical contradictions** TC-1 and TC-2 (one with strong tool action, one with weak tool action).
1.4 Choose the TC that better serves the **primary function** of the system.
1.5 Reinforce the chosen contradiction to its limit ("the tool must be *absent* yet still produce the effect").

## Part 2 — Analyse the problem's resource model

2.1 Define the **operational zone (OZ)**: the region where the conflict actually occurs.
2.2 Define the **operational time (OT)**: T₁ — before the conflict; T₂ — during; T₃ — after.
2.3 Enumerate **substance-field resources (SFR)** available in OZ ∪ OT — internal, external (environmental), derived (byproducts, voids, fields already present).

## Part 3 — Define the Ideal Final Result and the Physical Contradiction

3.1 IFR-1: "The X-element, *itself*, eliminates the harmful effect while preserving the useful one, *during OT, in OZ, using SFR*."
3.2 Sharpen IFR to **macro-level PC**: "An element in OZ during OT must be **A** AND **¬A**."
3.3 Drop to **micro-level PC**: "Particles in OZ during OT must produce **A** AND **¬A**."
3.4 State IFR-2: an *available* resource must perform the contradictory function unaided.

## Part 4 — Mobilise and apply substance-field resources

4.1 Try **separation in space, time, condition, system levels** (see `separation_principles.md`).
4.2 Apply the **76 Standard Solutions** (see `76_standard_solutions.md`) to the Su-Field model in OZ.
4.3 Use **smart substances**: ferromagnetic particles + field, capillary substances, foams, phase-changing media.
4.4 Use the *empty* resource: introduce a **void** where a substance was expected.

## Part 5 — Apply the knowledge base of effects

If Parts 1–4 produced no candidate, search the **TRIZ effects database** — physical, chemical, geometric, biological effects indexed by function. (E.g. "heat without flame" → exothermic chemical reactions, magnetocaloric effect, induction, friction; "move without motor" → capillarity, thermal expansion, electrostatics.)

## Part 6 — Change or re-formulate the problem

6.1 If still stuck, *re-examine the mini-problem*: was the conflicting pair correctly identified?
6.2 *Combine* mini-problems: solve a wider problem of which the original is a sub-case.
6.3 *Decompose* the problem into independent sub-problems.
6.4 *Replace* the problem with the inverse one: instead of preventing X, exploit X.

## Part 7 — Analyse the solution

7.1 Test the candidate solution against the IFR — closeness to ideality.
7.2 Verify that the **physical contradiction** is actually *resolved*, not merely *compromised*.
7.3 Identify side-effects, secondary contradictions, and required validation experiments.

## Part 8 — Apply the solution

8.1 Determine how the solution changes neighbouring systems and the supersystem.
8.2 Identify new problems introduced — these become input to a fresh ARIZ pass.

## Part 9 — Analyse the solution process

9.1 Compare the actual solution path to the "ideal" path through ARIZ.
9.2 Record deviations as input to refining the algorithm and the knowledge base.

## Operational checklist (compressed)

```
[ ] 1. Mini-problem stated; conflicting pair named; TC-1, TC-2, primary TC chosen
[ ] 2. OZ defined; OT segmented (T1/T2/T3); SFR enumerated
[ ] 3. IFR-1 → macro PC → micro PC → IFR-2
[ ] 4. Separation axis tested; Standard Solutions applied; smart substances / voids tried
[ ] 5. Effects database consulted
[ ] 6. Problem reformulated if no candidate
[ ] 7. Candidate evaluated against IFR and ideality
[ ] 8. Supersystem impact assessed; new problems queued
[ ] 9. Solution path post-mortemed
```

## When to invoke ARIZ vs the quickstart workflow

| Symptom | Use |
|---------|-----|
| Contradiction is clear, matrix returns 2–4 principles, one obviously fits | Quickstart (Steps 1–5) |
| Matrix cell empty / multiple principles all weak | Add separation + Standard Solutions |
| Problem feels "stuck", concepts keep compromising | **ARIZ-85C (this file)** |
| Need a roadmap rather than a fix | Trends of Evolution (`evolution_trends.md`) |

## How to use this file

Invoke when the user explicitly asks for "deep TRIZ" / "ARIZ analysis" *or* when the quickstart workflow produced no concept with ideality > 1 (see `glossary.md`). Treat each part as a discrete intake step — do not skip to a later part until the current one produced its required artefact.
