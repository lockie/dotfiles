# Glossary

Short, operational definitions of TRIZ terms used in this skill. Where applicable, each term lists the file in which it is operationalised.

| Term | Definition | Where used |
|------|------------|------------|
| **TRIZ** | *Teoriya Resheniya Izobretatelskikh Zadach* — Theory of Inventive Problem Solving. A patent-derived methodology that resolves engineering contradictions algorithmically. | All |
| **Technical contradiction (TC)** | A trade-off: improving parameter A degrades parameter B. Resolved via the Contradiction Matrix → 40 Inventive Principles. | `SKILL.md`, `40_principles.md`, `contradiction_matrix.json` |
| **Physical contradiction (PC)** | A single element must exhibit two opposite properties. Resolved via separation in space / time / condition / system level. | `separation_principles.md` |
| **Ideal Final Result (IFR)** | The hypothetical end-state where the required function is performed perfectly with zero added cost, complexity, or harm — by the system itself. The North Star of TRIZ. | `SKILL.md` step 1, `ariz_85c.md` part 3 |
| **Ideality** | The figure-of-merit `(Σ useful functions) / (Σ harmful functions + Σ costs)`. TRIZ asserts that systems evolve toward higher ideality. | `SKILL.md` output section, `evolution_trends.md` trend 1 |
| **39 Engineering Parameters** | Altshuller's standard taxonomy of system parameters (weight, length, temperature, reliability, etc.). Axes of the Contradiction Matrix. | `39_parameters.md` |
| **40 Inventive Principles** | Cross-domain solution heuristics distilled from ~200,000 patents. Each is a directional hint, not a recipe. | `40_principles.md` |
| **Contradiction Matrix** | 39×39 lookup table mapping (improving, worsening) parameter pairs to 3–4 recommended Inventive Principles. | `contradiction_matrix.json` |
| **Su-Field (Substance–Field model)** | A triadic model of function: **S₁** (object) ← **F** (field) ← **S₂** (tool). Used to diagnose incomplete / insufficient / harmful interactions. | `SKILL.md` step 4, `76_standard_solutions.md` |
| **Field (F)** | The agent that carries action between S₂ and S₁. Hierarchy of controllability: mechanical → thermal → chemical → acoustic → electric → magnetic → electromagnetic. | `76_standard_solutions.md` |
| **76 Standard Solutions** | Five classes of canonical transformations of a Su-Field model. | `76_standard_solutions.md` |
| **ARIZ (Algorithm for Inventive Problem Solving)** | A 9-part formal procedure that converts a fuzzy problem into a sharp physical contradiction localised in operational zone and time, then attacks it with the Standard Solutions. The 1985 "C" revision is canonical. | `ariz_85c.md` |
| **Operational Zone (OZ)** | The spatial region where the conflict actually occurs. ARIZ part 2. | `ariz_85c.md` |
| **Operational Time (OT)** | The temporal interval where the conflict occurs, segmented as `T₁ (before) | T₂ (during) | T₃ (after)`. | `ariz_85c.md` |
| **Substance-Field Resources (SFR)** | Substances, fields, voids, byproducts available inside OZ ∪ OT — preferred over introducing new elements. | `ariz_85c.md`, `SKILL.md` step 5 |
| **Internal resource** | An unused property of an existing system component (idle time, geometric features, byproducts). | `SKILL.md` step 5 |
| **External resource** | An unused property of the environment (air, gravity, ambient temperature gradient, supersystem). | `SKILL.md` step 5 |
| **Temporal resource** | Time before, during, or after the operation that can carry work (pre-process preparation, parallel operation, post-process recovery). | `SKILL.md` step 5 |
| **Separation principle** | A meta-strategy for resolving a physical contradiction by placing the opposing properties on orthogonal axes (space / time / condition / system level). | `separation_principles.md` |
| **Trends of Engineering System Evolution** | Eight statistically observed trajectories along which engineering systems evolve (increasing ideality, supersystem transition, micro-level, dynamisation, etc.). | `evolution_trends.md` |
| **S-curve** | The performance-vs-time lifecycle of an engineering system: infancy → growth → maturity → decline. | `evolution_trends.md` |
| **Convolution (свёртка)** | The trend of multi-component sub-systems collapsing into one multifunctional element. Trend 6. | `evolution_trends.md` |
| **Bi-system / Poly-system** | A system formed by combining two or many copies of a homogeneous system. Trend 3 expression. | `evolution_trends.md` |
| **Mini-problem** | The reformulation of the raw problem as: *all elements unchanged, but the required result appears by itself*. ARIZ part 1. | `ariz_85c.md` |
| **Conflicting pair** | The product-tool pair in which the contradiction is localised. ARIZ part 1. | `ariz_85c.md` |
| **Smart substance** | A substance with field-controllable properties (ferromagnetic powder, electrorheological fluid, shape-memory alloy). | `76_standard_solutions.md`, `ariz_85c.md` |
| **Inferred (vs matrix-derived)** | A concept whose principle citation was generated by reasoning over the 40 principles rather than read from a populated matrix cell. Output must flag this distinction. | `SKILL.md` output section |
