# Trends of Engineering System Evolution

Altshuller's analysis of patent data showed that engineering systems evolve along a small set of recurring trajectories. These trends are *prognostic*: they tell you where a technology is statistically headed next. Use them for roadmapping, not for fixing an immediate contradiction.

The canonical eight trends:

| # | Trend | One-line statement | Diagnostic signal |
|---|-------|--------------------|-------------------|
| 1 | **Increasing ideality** | The ratio of useful to harmful + cost functions monotonically rises | Each generation does more with less mass / energy / parts |
| 2 | **Non-uniform development of parts** | Components evolve at different rates → bottleneck is the slowest-evolving sub-system | One sub-system has not improved while the rest have leapt ahead |
| 3 | **Transition to a supersystem** | After local saturation, the system merges with adjacent systems (bi-system, poly-system, hybrid) | Local performance is asymptoting; competitors are bundling functions |
| 4 | **Transition to the micro-level** | Macro mechanisms → particles → molecules → fields → vacuum | Move from gears to fluids to plasmas to information |
| 5 | **Increasing dynamism / flexibility** | Rigid → jointed → elastic → fluid → field-controlled → adaptive | More degrees of freedom appear in successive generations |
| 6 | **Increasing complexity, then simplification (convolution)** | Add sub-systems until convoluting them collapses the whole into a single multifunctional element | A previously-complex assembly becomes one composite or programmable part |
| 7 | **Matching and mismatching of components** | Resonance with the working frequency / scale of partner systems; then deliberate mis-matching for robustness | Performance gains accrue from tuning / detuning interfaces |
| 8 | **Reducing human involvement / automation** | Hand-tool → mechanised → automated → autonomous → self-improving | Human is moved out of the loop layer by layer |

## Lifecycle (S-curve) framing

Each trend operates inside the **S-curve** of a system's life: *infancy → growth → maturity → decline*. Trend application is phase-dependent:

| Phase | Dominant trend(s) | Strategy |
|-------|-------------------|----------|
| Infancy | 1 (ideality), 7 (matching) | Stabilise core function |
| Growth | 5 (dynamism), 6 (complexity) | Add sub-systems; optimise |
| Maturity | 6 (convolution), 3 (supersystem) | Multifunctional integration |
| Decline | 3 (supersystem), 4 (micro-level), 8 (automation) | Jump to a new S-curve |

## Diagnostic procedure for roadmapping

1. Locate the system on its **S-curve** (infancy / growth / maturity / decline) using performance-vs-time data.
2. List **competitors and adjacent systems** that could enable trend 3 (supersystem).
3. Identify the **slowest-evolving sub-system** (trend 2) — that is the next investment target.
4. For each trend 1–8, write a one-line projection of the system *in 1, 3, 10 years*.
5. Pick projections that *cluster* (multiple trends pointing the same direction) — these are robust roadmap directions.

## Worked micro-example

**System**: residential lithium-ion battery pack, 2026.
- S-curve phase: **maturity** (incremental Wh/kg gains).
- Trend 1: ideality plateau in Li-ion chemistry → semi-solid / solid-state next.
- Trend 4: macro electrode → nanostructured / 3D-printed lattice.
- Trend 8: passive BMS → predictive, cell-level autonomous.
- Trend 3: pack ↔ inverter ↔ home thermal storage as a poly-system.

Clustered projection: **solid-state cells in 3D lattice with cell-autonomous BMS, integrated with home thermal supersystem**. Three independent trends agree → robust direction.

## How to use this file

Invoke only when the user asks a *prognostic* question ("where is this technology going?", "give me a 5-year roadmap", "next-generation system architecture"). Do **not** invoke for an immediate contradiction-resolution task — the trends do not solve today's bottleneck, they only locate tomorrow's.
