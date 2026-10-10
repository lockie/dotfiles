# 76 Standard Solutions (Su-Field) — Working Reference

Altshuller's 76 Standard Solutions operationalise Su-Field analysis: given a diagnosed S₁–F–S₂ model, they prescribe canonical transformations to **synthesise**, **destruct**, **evolve**, or **measure** the system. The corpus is grouped into **5 classes** (13 + 23 + 6 + 17 + 17 = 76).

**Sources reconciled in this file**: Salamatov (1999) "TRIZ: The Right Solution at the Right Time"; Mann (2002) "Hands-On Systematic Innovation," Ch. 8; ICG Training & Consulting public training materials. Where translations diverge, the Salamatov 5-subclass split is used for Class 4.

## Class taxonomy

| Class | Name | When to invoke | # solutions |
|-------|------|----------------|-------------|
| 1 | **Composition & decomposition of Su-Fields** | System is incomplete (missing S₂ or F) or contains a harmful coupling | 13 |
| 2 | **Evolution of Su-Fields** | System is complete but the action is *insufficient* or *uncontrollable* | 23 |
| 3 | **Transition to supersystem or micro-level** | Local improvements have stalled; the bottleneck is structural | 6 |
| 4 | **Detection & measurement** | The problem is *information* — a quantity cannot be sensed, measured, or controlled | 17 |
| 5 | **Helpers / strategies for substance & field introduction** | How to introduce substances or fields with minimum cost (resource-driven) | 17 |

## Diagnostic flow

```
Draw current Su-Field model (S₁, S₂, F)
        |
        v
Is S₂ or F missing? ─yes─→ Class 1.1: synthesise the missing element
        | no
        v
Is F harmful? ─yes─→ Class 1.2: shield / destruct the harmful coupling
        | no
        v
Is F insufficient or uncontrollable? ─yes─→ Class 2: chain / dualise / dynamise / ferro-field
        | no
        v
Is the problem measurement rather than action? ─yes─→ Class 4: indirect / synthesised / improved measurement
        | no
        v
Has local optimisation stalled? ─yes─→ Class 3: drop to micro-level OR jump to supersystem
        |
        v
Apply Class 5 to economise: prefer existing resources, voids, phase changes, derived substances
```

## Su-Field algebra (notation used below)

- `S₁`, `S₂`, `S₃` — substances (objects)
- `F`, `F₁`, `F₂` — fields (mechanical, thermal, chemical, electromagnetic, gravitational, acoustic)
- `S₁ ─F→ S₂` — field F acts from S₁ on S₂ (useful action)
- `S₁ ─F_harm→ S₂` — harmful field action
- `S₁'` — modified version of S₁
- `[A] → [B]` — transformation from system state A to state B

---

## Class 1 — Composition & Decomposition of Su-Fields (13 solutions)

### Subclass 1.1 — Synthesis of Su-Fields (building incomplete models)

- **1.1.1 Synthesis of a simple Su-field.** If two objects S₁ and S₂ do not interact (or interact poorly), introduce a missing field F or a missing substance to complete the triad.
  `[S₁ + S₂] → [S₁ ─F→ S₂]`

- **1.1.2 Internal complex Su-field.** If an existing Su-field is ineffective and modifying primary elements is restricted, introduce a permanent additive into one of S₁ or S₂ to form an internal blend that interacts with F.
  `[S₁ ─F→ S₂] → [S₁ ─F→ (S₂ + S₃)]`

- **1.1.3 External complex Su-field.** If an existing Su-field is ineffective and internal modification is restricted, introduce a separate third substance S₃ between or around them to transmit or modify the action of F.
  `[S₁ ─F→ S₂] → [S₁ ─F→ S₃ ─F→ S₂]`

- **1.1.4 Su-field in environment.** If the existing system permits no additive or external substance, use the environment as S₃.

- **1.1.5 Su-field in environment with additive.** If the environment lacks the needed property, modify the environment by introducing additives.

- **1.1.6 Maximum mode of action.** When intense action on S₂ is required but it would damage S₁, the maximum mode is applied via an intermediate substance S₃.

- **1.1.7 Selective maximum action.** Apply minimal action overall, but maximal action at points where it's needed — via a substance that delivers a high-intensity field locally.

- **1.1.8 Use of materials whose phase changes signal the action.** Use a substance that changes state (colour, magnetism, geometry) at a critical threshold to enable / report the action.

### Subclass 1.2 — Destruction of Su-Fields (eliminating harmful action)

- **1.2.1 Elimination by introducing a third substance.** If F causes a harmful interaction between S₁ and S₂, introduce a third substance S₃ to intercept, shield, or neutralise the harmful action while maintaining required function.
  `[S₁ ─F_harm→ S₂] → [S₁ ─F→ S₃ blocks/modifies → S₂]`

- **1.2.2 Elimination by modifying existing substances.** If introducing a foreign substance is forbidden, derive S₃ by modification, phase change, or division of S₁ or S₂ themselves.
  `[S₁ ─F_harm→ S₂] → [S₁ ─F→ S₁' → S₂]`

- **1.2.3 Drain off the harmful action via a third substance.** Add S₃ that absorbs / channels away the harmful F before it reaches S₂.

- **1.2.4 Counter-field.** Apply a second field F₂ that neutralises the harmful F.

- **1.2.5 Switch off the magnetism above Curie point.** When the harmful interaction is mediated by a ferromagnetic substance, raise it above its Curie temperature to disable the coupling.

---

## Class 2 — Evolution of Su-Fields (23 solutions)

### Subclass 2.1 — Transition to complex Su-Fields

- **2.1.1 Chained Su-field.** A simple Su-field with poor control is converted into a chain by adding F₂ acting through an intermediate S₃.
  `[S₁ ─F₁→ S₂] → [S₁ ─F₁→ S₂ ─F₂→ S₃]`

- **2.1.2 Dual Su-field.** Introduce a second independent field F₂ acting in parallel with F₁ to enhance or guide the primary action (e.g. combine thermal + magnetic).
  `[S₁ ─F₁→ S₂] → [S₁ ─(F₁+F₂)→ S₂]`

### Subclass 2.2 — Forcing evolution / Dynamisation

- **2.2.1 Replace an uncontrollable field with a controllable one.** Order of controllability (worst → best): gravitational → mechanical → thermal → chemical → electric → magnetic → electromagnetic.

- **2.2.2 Fragment the substance.** Replace bulk S₂ with a finer, more responsive form (rod → grains → powder → liquid → gas).

- **2.2.3 Dynamise a static field.** Continuous → pulsed → modulated → resonant action; use frequency to match the system's resonance.

- **2.2.4 Structure the field.** Replace a uniform field with a structured one (gradients, patterns, periodic, standing waves).

- **2.2.5 Structure the substance.** Replace a uniform substance with a structured one (porous, layered, gradient, perforated).

### Subclass 2.3 — Transition to ferro-fields (F-Fields)

- **2.3.1 Use ferromagnetic substance + magnetic field.** Replace controllable but coarse mechanical action with magnetic action on a ferromagnetic intermediate — enables contactless, fine, remote control.

- **2.3.2 Ferromagnetic particles in a non-magnetic substance.** Disperse ferro particles in a liquid / gas / polymer to make the medium magnetically controllable.

- **2.3.3 Ferro-magnetic liquid (ferrofluid).** Use a colloidal suspension of ferro particles in a carrier liquid to shape, position, or seal via external magnetic field.

- **2.3.4 Use of capillary / porous structures with ferro substance.** Localise the ferro response geometrically.

- **2.3.5 Dynamise the ferromagnetic system.** Apply pulsed / modulated / rotating magnetic fields.

### Subclass 2.4 — Matching & mismatching rhythms

- **2.4.1 Match the frequency of the field to the natural frequency of the substance** (resonance amplifies useful action).

- **2.4.2 Mismatch the field's frequency from the natural frequency of an adjacent substance** (anti-resonance suppresses harmful coupling).

- **2.4.3 Use two periodic actions whose periods are different but related** (beats, modulation envelopes).

---

## Class 3 — Transition to Supersystem & Micro-Level (6 solutions)

### Subclass 3.1 — Transition to bi- and poly-systems

- **3.1.1 Bi-system / poly-system.** Combine the system with one or more identical or similar systems (parallel processing, redundancy, parallel processing chains).

- **3.1.2 Develop links between elements** of the bi-/poly-system (couple them through a shared substance or field).

- **3.1.3 Increase differences between elements** of the poly-system (from identical → similar → diverse → opposite — each step increases functional range).

### Subclass 3.2 — Transition to micro-level

- **3.2.1 Replace bulk substance with particles.** Powders, granules, foams, gels — increased surface area enables phenomena unavailable at bulk scale.

- **3.2.2 Use molecular- or atomic-level phenomena.** Surface tension, capillary action, adsorption, catalysis, phase transitions at interfaces.

- **3.2.3 Use fields acting on micro-structure.** Electric fields polarise; magnetic fields align; thermal gradients drive Marangoni / thermocapillary effects.

---

## Class 4 — Detection & Measurement (17 solutions)

### Subclass 4.1 — Indirect measurement methods

- **4.1.1 Modify rather than measure.** Replace the unmeasurable quantity with an easily measurable proxy by transforming the system.

- **4.1.2 Avoid measurement altogether.** Redesign so the quantity does not need to be known (e.g. self-regulating systems).

### Subclass 4.2 — Synthesis of measuring Su-fields

- **4.2.1 Synthesise a measuring Su-field from scratch** when none exists (introduce a sensing substance + field).

- **4.2.2 Use a copy of the object.** Acoustic, optical, magnetic, or thermal image — measure the copy, not the original.

- **4.2.3 Add a marker substance that announces the measured quantity** (dye, fluorescent tracer, indicator chemical, radioactive isotope).

- **4.2.4 Measure the field generated by the object** (electric, magnetic, thermal emissions) instead of measuring the object directly.

### Subclass 4.3 — Improving measuring systems

- **4.3.1 Chain the measuring Su-field** (cascade transduction stages — e.g. thermal → mechanical → electrical).

- **4.3.2 Improve resolution by dynamising the measurement** (sweep, scan, modulate, lock-in detection).

- **4.3.3 Measure the derivative or integral** (rate-of-change, accumulated quantity) instead of the instantaneous value.

### Subclass 4.4 — Measuring ferromagnetic substances

- **4.4.1 Use magnetic / electromagnetic phenomena** to detect ferromagnetic substances (Hall sensors, magnetoresistance, eddy currents).

- **4.4.2 Magnetise the object to measure something else about it** (saturation field reveals composition; Curie point reveals phase).

- **4.4.3 Use ferromagnetic additives** for trace detection in non-magnetic systems.

### Subclass 4.5 — Evolution of measuring systems

- **4.5.1 Transition to bi- / poly-measurement systems** (multiple sensors of same kind → multiple modalities → fused sensor arrays).

- **4.5.2 Combine measurement with action** (the system reports its own state through its operation).

- **4.5.3 Transition to micro-level measurement** (single-molecule sensing, scanning probe microscopy).

- **4.5.4 Make the measurement self-correcting** (feedback to compensate drift, cross-calibration between channels).

---

## Class 5 — Helpers: Strategies for Introducing Substances & Fields (17 solutions)

### Subclass 5.1 — Introduction of substances (under restrictions)

- **5.1.1 Use "nothing" instead of a substance.** Voids, cavities, vacuum, bubbles, foams.

- **5.1.2 Use a field instead of a substance** when adding substance is forbidden.

- **5.1.3 Use an external additive** that does not modify the system permanently.

- **5.1.4 Use the largest dose only where needed** (point application, gradient, selective concentration).

- **5.1.5 Use a substance that disappears after use** (sublimation, dissolution, evaporation, biodegradation).

### Subclass 5.2 — Introduction of fields (under restrictions)

- **5.2.1 Use an existing internal field** instead of introducing a new one (waste heat → useful heat; structural vibration → measurement).

- **5.2.2 Use external environmental fields** (gravity, ambient EM, solar radiation, wind).

- **5.2.3 Use fields produced by adjacent supersystems**.

### Subclass 5.3 — Phase transitions

- **5.3.1 Use phase transitions** (solid ↔ liquid ↔ gas) for efficient field-substance interaction.
  `S → S_phase-transition`

- **5.3.2 Use dual-phase states** (ice-water mixtures, gas-liquid aerosols, porous structures saturated with liquid) that match varying operational requirements dynamically.
  `S → [S_phase-A + S_phase-B]`

- **5.3.3 Use phenomena that occur during transition** (volume change, heat absorption/release, magnetic property change, electrical conductivity jump).

### Subclass 5.4 — Use of physical & chemical effects

- **5.4.1 Self-controlled transitions.** Use a phenomenon whose threshold matches the required control point (Curie point, glass transition, eutectic melting).

- **5.4.2 Weak forces amplified by feedback** (lasing, avalanche photodiodes, chain reactions).

- **5.4.3 Energy conversion at thresholds** (piezoelectric, photovoltaic, thermoelectric, magnetostrictive).

### Subclass 5.5 — Generation of higher / lower forms of substance

- **5.5.1 Self-generation of useful substance** (substance derived from a system byproduct).

- **5.5.2 Use the inverse of a useful substance to neutralise harm** (acid + base; oxidiser + reducer).

- **5.5.3 Generate substance particles by decomposition** (electrolysis, ablation, sputtering, plasma discharge).

---

## How to cite Standard Solutions in skill output

When a generated concept derives from a standard solution, cite it inline by class.subclass.rule:

```
Source: standard-solution-2.3.1  (ferromagnetic substance + magnetic field for contactless control)
```

Each rule loosely maps to one or more of the 40 inventive principles. When producing the output, cite both:

```
Concept: magnetic positioning of a ferrofluid plug in a microfluidic valve
  Standard solution: 2.3.3 (ferrofluid)
  Inventive principles: #28 Mechanics substitution, #29 Pneumatics/Hydraulics
```

## How this file is used by the agent

In **Step 4** of the main SKILL.md workflow (Su-Field diagnosis), the agent:

1. Builds the current Su-Field model (S₁, F, S₂).
2. Routes through the diagnostic flow above to the matching class.
3. Walks the class's subclass rules as a checklist of available transformations.
4. For each plausible transformation, generates a concrete engineering concept that consumes a named resource.
5. Cites `Source: standard-solution-<class.subclass.rule>` in the output.

The diagnostic flow is deterministic — no creativity required from the agent until Step 4 of generating the concrete embodiment.
