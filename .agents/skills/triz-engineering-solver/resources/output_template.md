# Output Template

Use this template verbatim. Every TRIZ analysis must produce the four sections below in this order. Brevity is mandatory — this is an engineering deliverable, not an essay.

---

## 0. Intake summary (always)

```
System            : <one sentence>
Primary function  : <verb + object>
Problem           : <one sentence>
Constraints       : <bulleted; cost, manufacturing, regulatory, environmental>
Available resources : <bulleted; internal / external / temporal>
```

## 1. Contradiction statement

Choose **one** block.

### 1a. Technical contradiction

```
TC: improving [Parameter #<NN> — <name>] causes [Parameter #<MM> — <name>] to worsen.
Matrix cell (#NN, #MM): [principle IDs from contradiction_matrix.json, or "EMPTY → reasoning fallback"]
```

### 1b. Physical contradiction

```
PC: [Element X] must be [Property P] AND [Property ¬P].
Separation axis chosen: [space | time | condition | system level]
Linked principles (see separation_principles.md): [list of IDs]
```

## 2. Ideal Final Result

```
IFR: The system achieves <function> using <existing resource>,
without adding <cost | complexity | harm>,
because <element X> performs the contradictory action by itself
in the operational zone <OZ> during the operational time <OT>.
```

## 3. Inventive concepts (3–5)

Repeat the block below 3 to 5 times. **Drop any concept whose calculated ideality (section 4) is ≤ 1.**

```
### Concept <N>: <short title>

- Principle(s)      : #<NN> <Name> [+ #<MM> <Name>]
- Source            : matrix | inferred | standard-solution-<class.subclass> | separation-<axis>
- Description       : <2–3 sentences, concrete engineering action>
- Resource consumed : <one resource from the intake list>
- Implementation    : <2–4 bullet steps, technical pathway>
- Useful functions  : <bulleted, each with rough quantification or units>
- Harmful functions : <bulleted, ditto>
- Costs             : <bulleted; capex, complexity, manufacturing penalty>
- Ideality          : Σuseful / (Σharmful + Σcosts) = <numeric estimate, 0.x to 10>
- Validation risks  : <bulleted; what experiment / model / simulation is needed>
```

## 4. Principle-to-concept summary table

```
| # | Concept            | Principle(s)   | Source   | Key resource    | Ideality | Risk |
|---|--------------------|----------------|----------|-----------------|----------|------|
| 1 | <title>            | #15, #19       | matrix   | <resource>      | 2.3      | low  |
| 2 | <title>            | #28            | inferred | <resource>      | 1.4      | med  |
| 3 | <title>            | #1, #40        | separation-space | <resource> | 3.1 | low  |
```

Sort rows by **Ideality descending**.

## 5. Recommendation

```
Top concept       : Concept #<N>
Rationale         : <one sentence, why it wins on ideality + risk>
Next action       : <one specific experiment / prototype / simulation>
Escalation        : if no concept reaches ideality > 1, invoke ARIZ (see ariz_85c.md).
```

---

## Notes for the agent

- **Never** omit the `Source` field. The user must know whether a principle came from a populated matrix cell, was inferred over the 40 principles, came from a Standard Solution (cite class.subclass), or from a separation axis.
- **Never** report a concept without quantifying ideality. If quantification is impossible, use the bands `low / medium / high` and explain why numeric estimation fails.
- **Never** compromise between the two opposing parameters. A compromise concept must be flagged and excluded.
- If all concepts cluster on the same principle, force diversity: at minimum two principles from different separation axes or different matrix cells.
