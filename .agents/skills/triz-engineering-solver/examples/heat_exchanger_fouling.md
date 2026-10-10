# Worked Example — Heat Exchanger Fouling (Petrochemical)

A TRIZ walkthrough for a classic process-industry contradiction. Demonstrates the **30→22** harm-versus-energy-loss pattern that appears across petrochem, marine cooling, food processing, and HVAC.

## Inputs

- **System**: Shell-and-tube heat exchanger in a crude distillation unit. Hot crude oil flows through tubes (or shell side) transferring heat to an opposing fluid. Primary function: recover thermal energy from the process stream.
- **Problem**: *Fouling* — soot, coke precursors, biological matter, and inorganic scale accumulate on tube surfaces. Heat-transfer coefficient drops over time. Conventional mitigation (installing mechanical baffles, hangers, or static mixers to increase turbulence) permanently raises the system pressure drop, eroding pumping efficiency and throughput.
- **Contradiction parameters**: improving cleanliness (reducing harmful deposition) currently requires flow obstructions that worsen energy loss in the pumping system.
- **Constraints**: ASME pressure-vessel envelope, refinery turnaround interval (~3–5 years between shutdowns), no contamination of the product stream, retrofit-friendly (existing exchanger geometry).
- **Resources**: process fluid itself, hot-side / cold-side temperature differential, tube wall geometry, downstream separator stages, existing utility nitrogen / steam mains.

## Step 1 — IFR

The exchanger surface stays clean using only the flow that already exists, without adding flow obstructions or external cleaning systems, where the fouling **never adheres** rather than being removed after the fact.

## Step 2 — Contradiction classification

**Technical contradiction**: improving **#30 Object-affected harmful factors** (reducing fouling deposition from foulants carried by the process stream) worsens **#22 Loss of energy** (added flow obstructions raise pressure drop, costing pumping power).

Secondary framing (also valid): **#27 Reliability** improving (longer interval between fouling-driven shutdowns) versus **#36 Device complexity** worsening (mechanical cleaning hardware). The 30→22 framing is preferred because it points at the underlying physical mechanism, not just the operational consequence.

## Step 3 — Matrix lookup

From `resources/contradiction_matrix.json`:

- Cell `30,22` → principles **[21, 22, 35, 2]**
  - **#21 Skipping (Rushing through)** — pass through the problematic flow regime quickly so deposits cannot consolidate
  - **#22 Blessing in disguise** — convert the harmful deposit into a useful self-cleaning mechanism (e.g. sacrificial layer that re-deposits as scrubber)
  - **#35 Parameter changes** — change surface or fluid properties so adhesion is energetically unfavourable
  - **#2 Taking out** — extract the foulant before it reaches the heat-transfer surface

Additional candidates surfaced by reasoning over the 40 principles (will be marked `Source: inferred`):

- **#1 Segmentation** — break the continuous flow into segments that can be treated independently
- **#18 Mechanical vibration** — shake the surface so deposits cannot adhere
- **#19 Periodic action** — alternate operating modes so fouling layers are disrupted before they consolidate
- **#36 Phase transitions** — use a phase change inside the fluid to mechanically disrupt the boundary layer

## Step 4 — Su-Field

`S₁` = tube wall, `S₂` = foulant particles in the fluid, `F` = chemical/thermal field driving adhesion. The interaction is **harmful** (deposition reduces heat transfer).

Diagnostic flow (see `resources/76_standard_solutions.md`) routes to **Class 1.2: Destruction of Su-Fields**:

- **1.2.1** — introduce a third substance S₃ between fluid and wall (a coating, a bubble layer, or a sacrificial film) → maps to Concepts 1, 3, 5 below.
- **1.2.2** — modify S₁ (the wall surface) so the harmful coupling is suppressed → maps to Concept 3.
- **1.2.4** — apply a counter-field F₂ (vibration, periodic flow) → maps to Concepts 2, 4.

## Step 5 — Resources

- **Internal**: pressure differential along the exchanger; existing tube geometry; hot-side temperature reserve.
- **External**: ambient utilities (N₂, steam, instrument air); gravity (for vertical exchangers); downstream separation stages already in the unit.
- **Temporal**: scheduled maintenance windows (free); flow start-up / shut-down transients; the *off-peak* cycle of plant load variation.

## Inventive concepts

### Concept 1 — Inert micro-bubble injection (multiphase boundary-layer disruption)

- **TRIZ principles**: #36 Phase Transitions, #1 Segmentation
- **Source**: inferred (Standard Solution 1.2.1 — interpose S₃; Class 5.3.2 dual-phase states)
- **Description**: Inject controlled micro-bubbles of inert gas (N₂, CO₂) at the exchanger inlet. The bubbles segment the continuous liquid into a gas-liquid two-phase flow. As bubbles deform and burst near the tube wall, localised pressure pulses and turbulent eddies disrupt the laminar sublayer where deposition occurs — preventing foulant nucleation without bulk pressure-drop penalty.
- **Resource utilized**: existing N₂ utility main (external); fluid's own kinetic energy carries the gas through (internal).
- **Implementation**: install gas-injection sparger at inlet; downstream separator already exists in most refineries.
- **Risks**: bubble carryover into downstream stages; potential cavitation erosion at high bubble collapse intensity; bubble distribution non-uniformity in long tubes. Pilot validation: monitor heat-transfer coefficient and pressure-drop drift over a 3-month run.
- **Ideality**: ~2.5 (high useful: no pressure penalty + extends run length 2–4×; low cost: existing utilities; moderate harmful: cavitation risk).

### Concept 2 — Ultrasonic transducers on tube bundles

- **TRIZ principles**: #18 Mechanical Vibration, #19 Periodic Action
- **Source**: inferred (Standard Solution 2.2.3 — dynamise the field via ultrasonic frequency)
- **Description**: Mount low-power piezoelectric transducers on the shell or tube-sheet, driving the tubes at 20–40 kHz. Vibration causes shedding of incipient deposits before they consolidate. Pulsed duty cycle (e.g. 30 s on every 10 min) limits energy use and fatigue.
- **Resource utilized**: plant electrical bus (supersystem).
- **Implementation**: external clamp-on transducers (retrofit-friendly), driver electronics in instrument cabinet.
- **Risks**: long-term fatigue at tube/tubesheet welds; transducer coupling under thermal cycling; bounded effectiveness against hard scale.
- **Ideality**: ~1.8 (useful: continuous cleaning without flow interruption; cost: power + capex moderate; harmful: weld-fatigue concern over multi-year run).

### Concept 3 — Low-surface-energy coating (DLC / fluoropolymer)

- **TRIZ principles**: #35 Parameter Changes, #3 Local Quality
- **Source**: inferred (Standard Solution 1.2.2 — modify S₁)
- **Description**: Apply a thin (~5–20 μm) low-surface-energy coating to the fouling-prone surface — diamond-like carbon (DLC), fluoropolymer, or sol-gel silica. Reduces foulant adhesion energy below the shear stress of normal flow, so deposits self-detach.
- **Resource utilized**: existing tube surface (internal geometric resource).
- **Implementation**: coat during scheduled turnaround.
- **Risks**: coating thermal resistance reduces overall heat-transfer coefficient by 3–8%; coating lifetime under thermal cycling and abrasive flow is 1–3 years (recoating cycle).
- **Ideality**: ~1.1 (useful: passive, zero operating cost once applied; harmful: thermal-resistance penalty often offsets cleanliness gain in high-flux service; cost: recoating burden).

### Concept 4 — Periodic flow reversal

- **TRIZ principles**: #13 The Other Way Round, #19 Periodic Action
- **Source**: inferred
- **Description**: Periodically reverse process-side flow direction (e.g. once per shift, or triggered by ΔP-rise threshold). Reversal disrupts the asymmetric foulant accumulation that builds in the direction of flow, mechanically shearing it off. No new substances or fields introduced.
- **Resource utilized**: existing flow energy (internal); existing valving with minor extension (supersystem).
- **Implementation**: add four-way valve manifold at exchanger inlets; sequence controlled by DCS logic.
- **Risks**: process-control complexity during reversal transients; downstream demand interruption; not all process geometries tolerate reversal.
- **Ideality**: ~2.0 (useful: uses existing resources; cost: control logic + valving; harmful: transient handling burden).

### Concept 5 — Self-cleaning ferromagnetic micro-scrubbers

- **TRIZ principles**: #28 Mechanics Substitution, #2 Taking Out
- **Source**: standard-solution-2.3.2 (ferromagnetic particles in non-magnetic substance)
- **Description**: Suspend ferromagnetic micro-particles (μm-scale) in the process fluid. External magnetic field along the tube length sweeps the particles across the inner wall, mechanically scouring it. Magnetic separator downstream recovers the particles for recirculation.
- **Resource utilized**: external magnetic field (supersystem); recirculated particles (internal closed-loop).
- **Implementation**: in-line magnetic exciter coils; high-gradient magnetic separator downstream.
- **Risks**: product contamination from particle escape past the separator; particle attrition over time; not compatible with paramagnetic or conductive product streams.
- **Ideality**: ~0.7 → **drop** (cost and contamination risk exceed clean-tube gain in mainstream petrochem service; could be ideality > 1 in food or specialty chemistry contexts where contamination is engineered around).

## Summary table

| # | Concept | Principle(s) | Source | Key resource | Ideality | Risk |
|---|---------|--------------|--------|--------------|----------|------|
| 1 | Inert micro-bubble injection | #36, #1 | inferred + SS 1.2.1 | N₂ utility + flow KE | 2.5 | Cavitation, carryover |
| 4 | Periodic flow reversal | #13, #19 | inferred | Flow energy | 2.0 | Control complexity |
| 2 | Ultrasonic transducers | #18, #19 | inferred + SS 2.2.3 | Electrical bus | 1.8 | Weld fatigue |
| 3 | Low-surface-energy coating | #35, #3 | inferred + SS 1.2.2 | Tube surface | 1.1 | Heat-transfer penalty |
| 5 | Ferromagnetic scrubbers | #28, #2 | SS 2.3.2 | External B-field | 0.7 | **Dropped** — contamination |

## Recommendation

**Top concept: #1 Inert micro-bubble injection.** Highest ideality (~2.5) because it consumes a free supersystem resource (N₂ utility), introduces no permanent flow obstruction, and the standard solution 1.2.1 / Class 5.3 phase-transition framing is well-grounded. Validation path: 3-month pilot loop with controlled foulant injection, instrumented for ΔP and heat-transfer coefficient drift; compare against an unprotected reference exchanger.

**Escalation rule**: if pilot fails to clear ideality > 1 under representative foulant load, invoke `resources/ariz_85c.md` to reformulate as a physical contradiction (*the wall must be in contact with the fluid for heat transfer AND not in contact for fouling prevention*) and apply separation-in-time or separation-by-condition (`resources/separation_principles.md`).

## Note

Concept 1 (multiphase flow with engineered bubbles) is documented in petrochemical TRIZ literature and has commercial deployments in refinery preheat trains; this analysis recovers it from first principles without consulting the answer. Concept 4 (flow reversal) is widely used in air-side fouling (HVAC, heat-recovery wheels) and increasingly in liquid-side service. Concept 3 (coatings) is mainstream in marine and food-processing but underperforms in high-flux petrochem service because of the thermal-resistance penalty.
