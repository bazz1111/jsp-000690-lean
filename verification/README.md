# Verification records

Two independent checks of the same construction.

## 1. `cross-check.py` — independent brute force

Pure Python 3, standard library only, no dependency on Lean. Re-derives every claim
from the edge list and the certificate tables rather than reusing the paper's script.

```bash
python3 cross-check.py
```

Expected: `13/13 checks passed` and `CONSTRUCTION VERIFIED`. It checks 3-uniformity,
the degree vector, non-2-colourability, edge-criticality, vertex-criticality, and both
certificate tables.

## 2. `axioms.lean` — kernel axiom audit

```bash
lake env lean verification/axioms.lean
```

Expected: each of the ten theorems reports `depends on axioms: [propext]`, exactly as
recorded in `axioms-output.txt`. `propext` is one of the three Lean standard axioms
(`propext`, `Classical.choice`, `Quot.sound`); it enters through `decide`, which turns
a `Bool` equality into a proposition. Any axiom outside that set — in particular
`sorryAx`, or a project-local `axiom` declaration — would mean a proof is not the
closed kernel computation it is claimed to be.

## 3. `lake build` — type checking

```bash
lake build
```

Expected: no errors, no warnings.

## What is deliberately absent

No `sorry`, no `admit`, no `native_decide`, no `axiom` declaration, no `unsafe`, and
no Mathlib or Batteries dependency. `native_decide` is avoided on purpose: it closes
goals by compiling to native code and executing it, which places the compiler and the
runtime inside the trusted base. Every finite claim here is instead discharged by
`decide`, which reduces in the kernel.
