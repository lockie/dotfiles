---
name: triz-engineering-solver
description: Apply Altshuller's TRIZ (Theory of Inventive Problem Solving) to resolve engineering contradictions and produce inventive concepts instead of compromise solutions. TRIGGER when the user describes a technical trade-off ("improving X makes Y worse"), a physical contradiction (one element must have opposite properties), a design bottleneck where conventional optimization has stalled, or explicitly asks for inventive / non-obvious / breakthrough engineering solutions. Uses the Ideal Final Result (IFR), 39 engineering parameters, 40 inventive principles, Contradiction Matrix, Su-Field analysis, and resource mapping. DO NOT TRIGGER for software architecture without a physical analogue, UX/UI design, business strategy, organizational problems, or open brainstorming where no concrete contradiction has been identified — TRIZ degrades into generic advice outside physical/technical systems.
---

# TRIZ Engineering Solver

A systematic analytical engine for solving engineering problems with Genrich Altshuller's Theory of Inventive Problem Solving (TRIZ). Replaces trial-and-error brainstorming with algorithmic problem-solving over a corpus of patent-derived patterns.

## When to use

- Engineering trade-offs where improving parameter A degrades parameter B (technical contradiction)
- A single element must exhibit opposite properties (physical contradiction)
- Design bottleneck where conventional optimization has plateaued
- System redesign aimed at the Ideal Final Result

## When NOT to use

- Pure software architecture without a physical analogue
- UX / interaction design
- Business or organizational strategy
- Open brainstorming with no concrete contradiction identified

## Inputs required

Before analysis, collect from the user:

1. **System description** — current engineering system and its primary function
2. **Problem statement** — the specific bottleneck or undesired effect
3. **Contradiction parameters** — which parameter must improve, which one degrades
4. **Constraints** — environmental, cost, manufacturing, physical limits
5. **Available resources** — substances, fields, geometry, byproducts, environment

If any input is missing, use the self-prompting block in `## Intake prompt` below.

## Workflow

### Step 1 — Formulate the Ideal Final Result (IFR)

Describe the outcome where:
- The desired function is achieved perfectly
- No additional cost, complexity, or harmful side-effect is introduced
- Only existing internal / external / temporal resources are used
- The problem "solves itself"

Question to drive Step 1: *"In an ideal world, how would this system achieve [desired function] using only what already exists, with zero added complexity?"*

### Step 2 — Classify the contradiction

**Technical contradiction**: improving parameter A causes parameter B to worsen.
- *Example*: increasing strength (A) increases weight (B).

**Physical contradiction**: a single element must exhibit opposite properties simultaneously or under different conditions.
- *Example*: a surface must be rough (for grip) and smooth (for low friction).

Physical contradictions are typically resolved by **separation** in space, time, condition, or system level (parts vs. whole). For the decision procedure and the principles linked to each separation axis, see `resources/separation_principles.md`. Technical contradictions are resolved via the Contradiction Matrix → Inventive Principles.

### Step 3 — Map to the Contradiction Matrix

1. Identify the **improving parameter** from the 39 — see `resources/39_parameters.md`.
2. Identify the **worsening parameter** from the 39.
3. Look up the cell in `resources/contradiction_matrix.json`. The cell lists 3–4 recommended inventive principle IDs.
4. For each suggested principle, retrieve its full description and sub-principles from `resources/40_principles.md`.
5. Apply the principles to the concrete system to generate candidate solutions.

> **Note**: `resources/contradiction_matrix.json` contains the full Altshuller 39×39 matrix (1190 populated cells; 292 cells are legitimately empty in the original — Altshuller's patent analysis found no dominant principle for those contradictions). For empty cells, fall back to reasoning over the 40 principles directly and mark the suggestion as `Source: inferred` rather than `Source: matrix`. See the JSON `meta.primary_source` for transcription provenance.

### Step 4 — Su-Field (Substance–Field) analysis

Model the system's function as a triad:
- **S1** — object being acted upon
- **S2** — tool / agent acting on S1
- **F** — field carrying the action (mechanical, thermal, chemical, electromagnetic, gravitational, acoustic)

Diagnose:
- **Incomplete system** (missing S2 or F): add the missing element, preferring existing resources.
- **Insufficient/ineffective interaction**: introduce a more controllable field, intermediate substance, or field additive.
- **Harmful interaction**: insert a barrier substance, introduce a counteracting field, or modify field properties.

For systematic Su-Field transformations, consult `resources/76_standard_solutions.md` — class taxonomy, diagnostic flow, and the most-cited operational sub-rules of the **76 Standard Solutions** (Altshuller, grouped into 5 classes). When you cite a Standard Solution, mark `Source: standard-solution-<class.subclass>` in the output.

### Step 5 — Resource utilization

Enumerate before generating concepts:

- **Internal resources**: unused properties of components, byproducts, idle time, geometric features (holes, surfaces, edges).
- **External resources**: environmental substances (air, water, gravity), environmental fields (magnetic, thermal gradients), supersystem (adjacent systems).
- **Temporal resources**: pre-process preparation, post-process utilization, parallel operations.

Prefer concepts that consume **free** resources over concepts requiring new components.

### Step 6 (optional) — ARIZ deepening

For hard problems where the 40-principles pass yielded no strong concept (no concept reaches `ideality > 1`, see Output format below), switch to **ARIZ-85C** (Algorithm for Inventive Problem Solving) — a formal 9-part procedure that reframes the problem mini-problem → operational zone → operational time → substance-field resources → IFR-1 → physical contradiction → standard solution. Full procedure and operational checklist: `resources/ariz_85c.md`. Invoke explicitly when the user asks for "deep TRIZ" / "ARIZ analysis" or when the quickstart fails the ideality bar.

### Step 7 (optional) — Trends of Engineering System Evolution

For prognostic / roadmapping questions ("where will this technology go next?"), map the system to the 8 trends (increasing ideality, non-uniform development of parts, transition to supersystem, transition to micro-level, increasing dynamism, complexity → convolution, matching/mismatching, reducing human involvement). Full list, S-curve framing, and the diagnostic procedure: `resources/evolution_trends.md`. Out of scope for the contradiction-resolution workflow above — invoke only when the user's question is prognostic, not corrective.

## Output format

The full machine-readable template lives in `resources/output_template.md` — **use it verbatim**. The sections below are the inline summary for quick reference. Every concept must report a numeric (or banded) **ideality** estimate (see "Ideality metric" below). Concepts with `ideality ≤ 1` are dropped, not compromised.

Generate a structured analysis containing the sections below. Keep each section tight; this is an engineering deliverable, not an essay.

### 1. Contradiction statement

```
Technical contradiction: improving [Parameter A, with #] causes [Parameter B, with #] to worsen.
— OR —
Physical contradiction: [Element X] must be [Property 1] AND [Property 2].
  Separation strategy candidate: [space | time | condition | system-level].
```

### 2. Ideal Final Result

```
IFR: The system achieves [desired function] using [existing resource],
without adding [cost/complexity/harm], where [problem element] solves itself.
```

### 3. Inventive concepts (3–5)

For each concept:

- **Concept name** — short descriptive title
- **TRIZ principle(s) applied** — number + name (from `resources/40_principles.md`)
- **Source** — one of `matrix` (cell-derived), `inferred` (reasoning over the 40 principles), `standard-solution-<class.subclass>` (Su-Field, see `resources/76_standard_solutions.md`), or `separation-<axis>` (physical contradiction, see `resources/separation_principles.md`)
- **Description** — specific, actionable engineering solution (2–3 sentences)
- **Resource utilized** — which internal / external / temporal resource is leveraged
- **Implementation path** — high-level technical pathway
- **Risks / open questions** — what would need to be validated experimentally

### 4. Principle-to-concept summary table

Sorted by **Ideality descending**.

| # | Concept | Principle(s) | Source | Key resource | Ideality | Risk |
|---|---------|--------------|--------|--------------|----------|------|

### 5. Recommendation

State the top concept, the rationale (one sentence on ideality + risk), the next concrete validation action (experiment / prototype / simulation), and an escalation rule: if no concept reaches `ideality > 1`, invoke ARIZ (`resources/ariz_85c.md`).

## Ideality metric

For each concept compute:

```
ideality = Σ (useful functions) / (Σ (harmful functions) + Σ (costs))
```

- *Useful functions*: each output the concept delivers (deceleration, heat dissipation, safety isolation, …) — count and, where possible, quantify.
- *Harmful functions*: side-effects the concept introduces (NVH, mass penalty, leaked field, …).
- *Costs*: capex, complexity, manufacturing penalty, certification burden, lifetime degradation.

Numeric estimation is preferred. When quantities are unavailable, use the bands `low (≤1) | medium (1–3) | high (>3)` and explain why a numeric estimate is impossible. A concept with `ideality ≤ 1` must be dropped — TRIZ forbids compromise solutions.

## Intake prompt

If any required input is missing, ask the user:

```
To run TRIZ analysis I need:

[ ] System description — what is the system and its primary function?
[ ] Problem statement — what bottleneck or unwanted effect must be resolved?
[ ] Contradiction — which parameter must improve, and which one degrades?
[ ] Constraints — cost, dimensional, environmental, manufacturing limits?
[ ] Resources — substances, fields, geometry, byproducts available?

Please fill the gaps so I can generate inventive concepts.
```

## Agent instructions

1. **Scope check** — before intake, confirm the problem is engineering: physical system, physical field, measurable physical parameters. If not, refuse-with-reframe per `examples/anti_example_misframed.md`.
2. **Intake** — collect all five inputs; do not proceed with placeholders.
3. **Analysis** — execute Steps 1–5 in order. Step 6 (ARIZ-85C, `resources/ariz_85c.md`) and Step 7 (Trends, `resources/evolution_trends.md`) only on explicit request or as the ARIZ escalation triggered by failing the ideality bar.
4. **Synthesis** — produce 3–5 concrete concepts, not generic advice. Use `resources/output_template.md` verbatim.
5. **Citation** — always reference principle by `#NN — Name` and mark `Source: matrix | inferred | standard-solution-<class.subclass> | separation-<axis>`.
6. **Validation** — every concept must (a) name the principle, (b) name the resource it consumes, (c) report a numeric or banded **ideality** estimate, (d) state at least one open validation risk.
7. **Ideality bar** — drop any concept with `ideality ≤ 1`. If no concept clears the bar, escalate to ARIZ-85C rather than compromise.
8. **Anti-pattern** — never compromise between A and B; the point of TRIZ is to *resolve* the contradiction, not split the difference. Compromise candidates must be listed as `Source: rejected` for discipline.

## Example applications

- `examples/brake_disc.md` — automotive brake disc (friction vs heat dissipation). Mechanical / thermal contradiction; canonical TRIZ recovery of the ventilated-disc industry solution from first principles.
- `examples/battery_pack.md` — EV battery pack (energy density vs thermal safety). Electromechanical, contemporary; demonstrates the *physical contradiction* path via separation-by-condition and the 76 Standard Solutions.
- `examples/heat_exchanger_fouling.md` — petrochemical heat exchanger (fouling vs pressure-drop). Process-industry contradiction; demonstrates the **30→22** harm-versus-energy-loss pattern, Su-Field Class 1.2 destruction routing, and the ideality drop rule (one concept eliminated).
- `examples/anti_example_misframed.md` — UX onboarding flow (out-of-scope). Demonstrates the **refuse-with-reframe** behaviour when the problem is not engineering.

## Resources

- `resources/39_parameters.md` — the 39 engineering parameters with definitions
- `resources/40_principles.md` — the 40 inventive principles with sub-principles
- `resources/contradiction_matrix.json` — full Altshuller 39×39 matrix (1190 populated cells out of 1482 non-diagonal; the 292 empty cells reflect contradictions for which Altshuller's analysis surfaced no dominant principle)
- `resources/separation_principles.md` — four-axis decision procedure for physical contradictions, linked to the 40 principles
- `resources/76_standard_solutions.md` — full 5-class / subclass taxonomy of the 76 Standard Solutions with Su-Field algebra notation, diagnostic flow, and rule texts (reconciled from Salamatov 1999, Mann 2002, ICG Training & Consulting materials)
- `resources/ariz_85c.md` — ARIZ-85C nine-part deep-analysis procedure with operational checklist
- `resources/evolution_trends.md` — eight trends of engineering system evolution + S-curve framing for roadmapping
- `resources/glossary.md` — operational definitions of every term used in the skill
- `resources/output_template.md` — machine-readable output template (use verbatim)

## References

- Altshuller, G. (1984). *Creativity as an Exact Science*.
- Altshuller, G. (1999). *The Innovation Algorithm: TRIZ, Systematic Innovation and Technical Creativity*.
- Mann, D. (2002). *Hands-On Systematic Innovation*.
- Souchkov, V. *Breakthrough Thinking with TRIZ for Business and Management*.

## Tags

#triz #engineering #problem-solving #innovation #systematic-invention #contradiction-resolution #inventive-principles
