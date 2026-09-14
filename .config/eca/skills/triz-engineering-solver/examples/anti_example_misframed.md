# Anti-Example — When TRIZ Should Refuse (Misframed Problem)

A worked walkthrough of what happens when the user brings a problem outside TRIZ's domain. The point is to discipline the agent: **the correct output is a refusal-with-reframe, not a degraded TRIZ analysis**.

## Inputs (as supplied by the user)

- **System**: "Our SaaS onboarding flow."
- **Primary function**: "Convert sign-ups into paying users."
- **Problem**: "Users drop off on step 3 of the onboarding wizard."
- **Contradiction parameters (user's framing)**: "We want to ask for more profile information (higher data quality) but that makes drop-off worse."
- **Constraints**: "Marketing wants more fields; product wants conversion."
- **Resources**: "Engineering team, analytics, A/B testing infra."

## Why this is a TRIZ anti-pattern

TRIZ originated from analysis of patents — engineering systems with **physical fields**, **substances**, and **measurable parameters** (force, temperature, mass, viscosity, electrical current, …). It does *not* generalise cleanly to:

- UX / human-decision flows
- Business or organisational strategy
- Software architecture without a physical analogue
- Open brainstorming with no concrete physical contradiction

Symptoms that you are about to misuse TRIZ:

1. The "parameters" do not appear in the 39 engineering parameters list and have no physical analogue (here: "data quality" and "conversion rate" — both are emergent properties of human behaviour, not engineering parameters).
2. The "field" in the Su-Field model would have to be *attention*, *motivation*, or *trust* — not in Altshuller's field hierarchy.
3. The "ideal final result" reduces to a tautology ("users complete onboarding by themselves") because the system has no measurable mechanism by which the IFR could be evaluated.
4. The 40 principles, when forced onto the problem, produce only *generic UX advice* dressed in TRIZ vocabulary — e.g. "principle #1 Segmentation → break the form into pages" — which is just standard product practice with extra steps.

## Correct agent behaviour

```
The supplied problem is outside the scope of TRIZ Engineering Solver.

Reason: "conversion rate" and "data quality" are not engineering parameters
in the Altshuller sense; the Su-Field model has no physical field carrying
the action; and the 40 principles will degenerate into generic UX advice
when forced onto a human-decision flow.

Recommended reframe (choose one):

  A. If there is an underlying physical/engineering problem (e.g. a piece of
     hardware is genuinely failing, a manufactured part is contradictory),
     describe THAT, not its business symptom.

  B. Otherwise, use a tool fit for purpose: UX research, A/B testing,
     funnel analysis, Jobs-to-be-Done, or behaviour-design frameworks.
     TRIZ is the wrong instrument.

If you believe the problem IS engineering and I have misclassified it,
please supply: (i) a physical system being acted upon, (ii) a measurable
physical parameter that must improve, (iii) a measurable physical
parameter that worsens.
```

## What *not* to do

Do **not** produce a TRIZ-shaped analysis with:

- "#1 Segmentation → split the form into 3 steps"
- "#10 Preliminary action → pre-fill fields from social login"
- "#25 Self-service → ask the user to validate their own data"

These are perfectly reasonable UX suggestions; *they did not require TRIZ*. Dressing standard practice in TRIZ vocabulary causes two harms:

1. It legitimises misapplication and erodes the user's trust the next time TRIZ would have been the right tool.
2. It hides the genuine engineering problems where TRIZ excels behind a flood of trivial pattern-matched outputs.

## Edge case — when the boundary is genuinely ambiguous

If the user brings a *hardware-software hybrid* (e.g. "the cooling fan controller's PID loop is unstable when temperature varies rapidly"), the physical contradiction is real: the controller must be *responsive* (fast loop) AND *stable* (slow loop). TRIZ applies — separation in time / condition is the right move. The test: can you name a physical field and a measurable physical parameter on both sides of the contradiction?

| Symptom | Engineering? | Use TRIZ? |
|---------|--------------|-----------|
| "Drop-off in onboarding wizard" | No | **No** — refuse + reframe |
| "PID loop instability with thermal disturbance" | Yes (control + thermal) | Yes |
| "Org-chart inefficiency" | No | **No** |
| "Compressor surge during demand spikes" | Yes (fluid + thermo) | Yes |
| "Pricing-page conversion" | No | **No** |
| "Anodised coating peels off after thermal cycling" | Yes (materials) | Yes |

## How to use this example

Read this whenever the intake step (Step 0 / Intake) produces parameters that do not map to the 39 engineering parameters. The correct action is **refuse-with-reframe**, not a forced analysis. This file exists to make that refusal explicit, not optional.
