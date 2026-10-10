# Worked Example — Automotive Brake Disc

A canonical TRIZ walkthrough demonstrating the full workflow on a familiar engineering object.

## Inputs

- **System**: Automotive disc brake — friction couple of pad against rotating disc converting kinetic energy into heat.
- **Problem**: *Brake fade* under prolonged or repeated heavy braking — friction coefficient drops as disc temperature rises, increasing stopping distance.
- **Contradiction parameters**: improving braking power requires more friction generation, which raises disc temperature and degrades reliability.
- **Constraints**: must fit existing wheel envelope, mass-production cost-sensitive, must remain serviceable.
- **Resources**: rotational airflow from wheel, existing disc geometry, vehicle electrical bus, ambient air.

## Step 1 — IFR

The brake disc dissipates heat using the rotational airflow it already generates, without adding external cooling systems, where the disc cools itself during operation in proportion to the energy it absorbs.

## Step 2 — Contradiction classification

**Technical contradiction**: improving **#10 Force** (clamping force / friction work) worsens **#17 Temperature** (disc temperature rises, causing fade).

A secondary framing is also valid: improving **#39 Productivity** (braking events per unit time) worsens **#27 Reliability** (friction coefficient stability under thermal stress).

## Step 3 — Matrix lookup

From `resources/contradiction_matrix.json`:

- Cell `10,17` → principles **[35, 10, 21]**
  - **#35 Parameter changes** — change thermal properties of material
  - **#10 Preliminary action** — pre-conditioning the disc before high braking demand
  - **#21 Skipping (Rushing through)** — high-rate process so heat doesn't have time to localise
- Cell `39,27` → principles **[1, 35, 10, 38]**
  - **#1 Segmentation** — divide disc into thermal zones
  - **#35 Parameter changes** — material property change at temperature threshold
  - **#10 Preliminary action** — pre-cool before braking events
  - **#38 Strong oxidisers** — chemistry-level material engineering

Both cells converge on **#35 Parameter changes** and **#10 Preliminary action** — strong signals that these principles should drive the leading concepts. Other principles useful for this contradiction but absent from the matrix cells (e.g. **#17 Another dimension** for internal cooling channels, **#36 Phase transitions** for latent-heat absorption) will be marked `Source: inferred` rather than `Source: matrix` in the concepts below.

## Step 4 — Su-Field

S1 = disc, S2 = brake pad, F = mechanical (friction) field. The interaction is *useful* (produces deceleration) and *harmful* (produces excessive heat). Standard fix for harmful side-effects: introduce a counteracting field — here a *thermal field* via forced convection or phase-change absorption.

## Step 5 — Resources

- **Internal**: disc thermal mass; disc surface area; geometric voids between disc faces.
- **External**: relative airflow from wheel rotation (free); ambient cold air; gravity-fed airflow under vehicle.
- **Temporal**: dwell time between braking events (cool-down window).

## Inventive concepts

### Concept 1 — Radial ventilation channels (ventilated disc)

- **TRIZ principles**: #1 Segmentation, #17 Another Dimension
- **Source**: inferred
- **Description**: Machine internal radial vanes between two disc faces forming centrifugal air pumps. Cool air enters at the hub, accelerates through the vanes, and exits at the rim — convective cooling scales with rotation speed (i.e. with braking demand).
- **Resource utilized**: rotational kinetic energy (free external resource).
- **Implementation**: cast disc with radial vane pattern; ~30% increase in cooling area vs solid disc.
- **Risks**: vane geometry sensitive to imbalance / NVH; debris ingress; manufacturing cost vs solid disc.

### Concept 2 — Phase-change material (PCM) inserts

- **TRIZ principles**: #36 Phase Transitions, #35 Parameter Changes
- **Source**: inferred
- **Description**: Embed sealed PCM capsules (e.g. metal-eutectic) inside the disc thermal mass. During braking the PCM melts, absorbing latent heat at ~constant temperature; between braking events it solidifies. Caps the peak disc temperature.
- **Resource utilized**: latent heat capacity of PCM (introduces a new internal substance — caveat: violates the "no new components" IFR ideal).
- **Implementation**: drill cavities in disc body, insert PCM-filled capsules, seal with caps.
- **Risks**: PCM melt point selection; long-term seal integrity under thermal cycling; mass penalty.

### Concept 3 — Surface microstructure for enhanced convection

- **TRIZ principles**: #3 Local Quality, #15 Dynamics
- **Source**: inferred
- **Description**: Laser-texture the non-friction faces of the disc with micro-fins or dimples to increase effective surface area for convective heat transfer and to trip the boundary layer for turbulent flow.
- **Resource utilized**: existing disc surface (geometric internal resource).
- **Implementation**: laser texturing post-machining.
- **Risks**: micro-cracking initiation; fouling by brake dust; long-run durability of texture.

### Concept 4 — Regenerative pre-cooling (cross-system, supersystem resource)

- **TRIZ principles**: #25 Self-service, #22 Convert harm into benefit
- **Source**: inferred
- **Description**: Couple the brake disc thermally to a thermoelectric (Peltier / Seebeck) module that converts a portion of the brake's heat into electricity, simultaneously cooling the disc and recovering energy to the vehicle battery.
- **Resource utilized**: harmful heat itself, converted into useful electricity (supersystem resource: vehicle electrical bus).
- **Implementation**: TE module mounted on caliper-side cooling plate, electrically wired to DC-DC into the LV bus.
- **Risks**: TE conversion efficiency low (~5–8%); module thermal ceiling; system complexity vs energy recovered.

### Concept 5 — Pulse-modulated braking (system-level, not disc-level)

- **TRIZ principles**: #19 Periodic Action, #20 Continuity of useful action
- **Source**: inferred (the 39,27 matrix cell suggests #1, #35, #10, #38 — Concept 5 brings in #19, #20 by reasoning about the temporal-resource available between braking events)
- **Description**: Replace continuous clamping in cruise descents with high-frequency pulsed clamping coordinated with ABS hardware. Same average deceleration, but each off-pulse window allows local disc cooling.
- **Resource utilized**: temporal resource (off-cycles between pulses).
- **Implementation**: firmware change in ABS / brake-by-wire controller.
- **Risks**: NVH / driver feel; pad wear pattern; legal certification.

## Summary table

| # | Concept | Principle(s) | Key resource | Risk level |
|---|---------|--------------|--------------|------------|
| 1 | Radial ventilation channels | #1, #17 | Rotational airflow | Low |
| 2 | PCM inserts | #36, #35 | Latent heat | Medium |
| 3 | Surface microstructure | #3, #15 | Disc surface area | Medium |
| 4 | Regenerative TE cooling | #25, #22 | Waste heat → electricity | High |
| 5 | Pulse-modulated braking | #19, #20 | Off-cycle time | Medium |

## Note

Concept 1 is the historically-converged industry solution (every modern performance disc is ventilated). TRIZ recovered it as a top-ranked concept from first principles without consulting the answer, validating the workflow. Concepts 2–5 represent the "frontier" set — solutions that exist in prototype or specialist applications but are not yet mass-market.
