# Worked Example — EV Battery Pack: Energy Density vs Thermal Safety

An electromechanical TRIZ walkthrough on a contemporary system where the trade-off is well-known and the inventive frontier is active.

## Inputs

- **System**: Lithium-ion EV battery pack — array of cylindrical or prismatic cells in a thermally managed enclosure.
- **Primary function**: Store electrical energy and deliver controllable power to the drivetrain over thousands of cycles.
- **Problem**: Packing cells closer raises gravimetric / volumetric energy density (good for range) but reduces inter-cell spacing for cooling and increases thermal-runaway propagation risk.
- **Contradiction parameters**: improving **#5 Area of stationary object** / **#7 Volume of stationary object** (denser packing) worsens **#27 Reliability** (thermal-runaway propagation) and **#17 Temperature** (peak cell temperature).
- **Constraints**: automotive cost target, UNECE R100 safety certification, 8–10-year warranty, mass-production cell formats.
- **Resources**:
  - *Internal*: cell-to-cell voids, electrolyte itself, current collector tabs, BMS sensors, casing surface.
  - *External*: ambient air, vehicle coolant loop, vehicle structural members, gravity.
  - *Temporal*: charging windows (slow events), parking dwell, regen-braking pulses.

## Step 1 — IFR

The pack stores maximum energy per unit volume while *the cells themselves* prevent thermal-runaway propagation, using only substances and fields already present in the cell or its immediate enclosure, with no added active cooling loop.

## Step 2 — Contradiction classification

Primary framing — **physical contradiction**:

> The inter-cell substance must be **thermally insulating** (to stop runaway propagation between cells) AND **thermally conductive** (to extract continuous-operation heat to the coolant).

Separation candidate: **condition** — conductivity must vary with temperature (high in normal range, collapsing to insulator above runaway threshold).

A parallel technical contradiction also holds: improving energy density (#7) worsens reliability (#27).

## Step 3 — Matrix and separation lookup

- Matrix cell (7, 27) — unpopulated in the shipped anchor set → reasoning fallback.
- Separation-by-condition (see `separation_principles.md`) links to principles: **#28 Mechanics substitution**, **#31 Porous materials**, **#35 Parameter changes**, **#36 Phase transitions**, **#37 Thermal expansion**, **#38 Strong oxidants**, **#39 Inert atmosphere**.

Manual reasoning surfaces:

- **#36 Phase transitions** — use a substance whose phase change at the runaway threshold absorbs heat and/or changes conductivity.
- **#31 Porous materials** — open-cell foam between cells; collapses on local overheating.
- **#35 Parameter changes** — temperature-dependent thermal interface material (TIM).
- **#3 Local quality** — different thermal properties at top vs side of each cell.
- **#22 Blessing in disguise** — exploit electrolyte vapour as a controlled vent path.

## Step 4 — Su-Field

S₁ = neighbouring cell (target), S₂ = a faulting cell (source of runaway), F = thermal field (radiation + conduction). The interaction is *harmful* (runaway propagation). Standard Solution **Class 1.2.1**: introduce a third substance S₃ between S₁ and S₂. Standard Solution **Class 2.2.3**: dynamise the field — let S₃'s thermal conductivity be a function of temperature.

## Step 5 — Resources used

- *Internal*: inter-cell void space (currently empty); cell can wall as conductive path.
- *External*: vehicle coolant loop (cold plate at pack floor).
- *Temporal*: charging-event downtime as a slow heat-soak window.

## Inventive concepts

### Concept 1 — Temperature-switching phase-change insulator

- **Principle(s)**: #36 Phase Transitions, #35 Parameter Changes
- **Source**: separation-condition
- **Description**: Fill inter-cell void with a paraffinic / metal-eutectic composite whose effective thermal conductivity drops by an order of magnitude when it melts at ~95 °C. In normal operation (<70 °C) it conducts heat to the cold plate; during a runaway event (>120 °C locally) it melts into a foamed insulator, blocking neighbour ignition.
- **Resource consumed**: inter-cell void (internal); ambient ΔT to coolant (external).
- **Implementation**: cast composite slug between cells; tune phase-change point per cell chemistry.
- **Useful**: dual conduct/insulate; passive (no BMS logic).
- **Harmful**: residual mass penalty; potential pack repair complexity.
- **Costs**: ~1–2 % capex on pack; tooling change.
- **Ideality**: Σuseful (passive safety + normal cooling, 2 functions) / (Σharmful + costs ≈ 1) → **~2.0**.
- **Validation risks**: melt-point drift after 1000 thermal cycles; mass impact on energy density target.

### Concept 2 — Cell can with radial micro-fins to coolant plate

- **Principle(s)**: #1 Segmentation, #17 Another Dimension, #3 Local Quality
- **Source**: inferred
- **Description**: Texture the cell-can bottom with radial micro-fins integrated into the cold plate via TIM. Heat path is from the cell terminal → can wall → fin array → cold plate, decoupled from inter-cell spacing.
- **Resource consumed**: existing cell-can surface; cold plate (external).
- **Implementation**: deep-draw the can with fin pattern; matching cold-plate pocket.
- **Useful**: enables denser side-by-side packing; conducts continuous heat.
- **Harmful**: does not address runaway propagation by itself.
- **Costs**: marginal can-tooling delta.
- **Ideality**: only ~1.2 alone, **must combine with concept 1 or 3**.
- **Validation risks**: can structural integrity after fin draw; TIM long-term performance.

### Concept 3 — Cell-level vent ducts to a common quench manifold

- **Principle(s)**: #22 Blessing in disguise, #2 Taking out
- **Source**: standard-solution-1.2.1
- **Description**: Each cell vent connects to a sealed manifold that channels vented electrolyte vapour *away from neighbouring cells* into an inert-quench chamber (e.g. with intumescent powder). The harmful vent itself becomes the propagation breaker.
- **Resource consumed**: vented electrolyte (formerly waste); empty space under pack floor (external).
- **Implementation**: per-cell vent collar + manifold + powder cartridge.
- **Useful**: directly prevents flame-front propagation; recoverable cells if event localised.
- **Harmful**: extra manifold mass; one-shot cartridge.
- **Costs**: meaningful capex (per-cell hardware).
- **Ideality**: **~2.5** (single failure mode addressed with no continuous penalty).
- **Validation risks**: vent timing under rapid runaway; manifold pressure rating.

### Concept 4 — Anti-example flagged for completeness

- **Principle(s)**: none — *compromise*
- **Source**: rejected
- **Description**: "Reduce energy density slightly to allow more inter-cell spacing for air cooling."
- **Why rejected**: this is a *compromise between the two opposing parameters*, not a *resolution* of the contradiction. TRIZ explicitly forbids this. Listed only to discipline downstream readers.

## Summary table (sorted by ideality)

| # | Concept | Principle(s) | Source | Key resource | Ideality | Risk |
|---|---------|--------------|--------|--------------|----------|------|
| 3 | Vent-duct + quench manifold | #22, #2 | standard-solution-1.2.1 | Vented electrolyte + under-pack void | 2.5 | medium |
| 1 | Phase-change inter-cell insulator | #36, #35 | separation-condition | Inter-cell void | 2.0 | medium |
| 2 | Radial-fin cell can | #1, #17, #3 | inferred | Can surface + cold plate | 1.2 (standalone) | low |
| — | Spacing compromise | — | rejected | — | — | — |

## Recommendation

Top concept: **Concept 3** for safety-critical certification; combine with **Concept 2** for the continuous-cooling path; **Concept 1** as the passive backup if mass budget permits all three. Next action: thermal-runaway propagation test (UN 38.3-style) on a 4-cell module instrumented for each variant.

## Note on what TRIZ recovered

TRIZ surfaced the industry-converged direction (vent-duct manifolds, used by major OEMs since ~2022) and a frontier direction (temperature-switching composites, currently in R&D papers) from first principles, *without* domain-specific battery knowledge — the trade-off being that domain expertise is still needed to set numeric thresholds (melt points, manifold pressures).
