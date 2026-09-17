# JSP-000690 — a 3-uniform 3-chromatic-critical hypergraph of minimum degree 7

A self-contained Lean 4 formalization answering the problem recorded as
**JSP-000690** in the [Justin Sun Prize problem bank](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0601-0700.md#JSP-000690):

> Is there a three-uniform, three-chromatic-critical hypergraph with minimum degree at least seven?

The answer is **yes**. This repository pins the explicit 9-vertex, 22-edge example
together with a machine-checkable proof that it has the required properties.

## The statement being proved

A hypergraph is **3-chromatic-critical** here in the chromatic sense — critical with
respect to weak vertex-colourings:

* it is not 2-colourable, and
* deleting any single edge, or any single vertex, makes it 2-colourable.

The formalized result (`Jsp000690.exists_critical_min_degree_seven`) is:

```lean
theorem exists_critical_min_degree_seven :
    ∃ H : HGraph, IsThreeChromaticCritical H ∧ MinDegreeAtLeast H 7
```

Concretely, for the pinned `H`:

| Property | Lean name | Method |
| --- | --- | --- |
| 3-uniform | `three_uniform` | kernel reduction |
| every vertex in ≥ 7 edges | `min_degree_at_least_seven` | kernel reduction |
| degree vector is `[10,7,7,7,7,7,7,7,7]` | `degrees` | kernel reduction |
| not 2-colourable | `not_two_colorable` | all 512 colourings, kernel reduction |
| 3-colourable | `three_colorable` | explicit colouring |
| `H − e` 2-colourable for every edge | `edge_critical` | kernel reduction |
| `H − v` 2-colourable for every vertex | `vertex_critical` | kernel reduction |
| the paper's edge-deletion certificates | `edge_certs_valid` | kernel reduction |
| the paper's vertex-deletion certificates | `vertex_certs_valid` | kernel reduction |

## What is *not* claimed

The source paper resolves the Erdős–Lovász question under **two** interpretations.
This repository formalizes only the **chromatic** interpretation, because that is the
reading the problem-bank entry records. The **transversal** interpretation — that a
3-uniform `τ`-critical hypergraph of order 3 has at most 10 edges, sharp at `K_5^(3)` —
is **not** formalized here. Nothing in this repository addresses it.

The construction itself is due to Ruiliang Li, not to the author of this
formalization. See [NOTICE](NOTICE).

## Build

Requires [elan](https://github.com/leanprover/elan). The toolchain is pinned by
`lean-toolchain` to `leanprover/lean4:v4.34.0`; no Mathlib and no other dependency
is used, so the build is small and fast.

```bash
git clone https://github.com/bazz1111/jsp-000690-lean
cd jsp-000690-lean
lake build
```

Expected: no errors, no warnings.

## Verification

`lake build` type-checks every theorem. The proof terms contain no `sorry`, no
`admit`, no `native_decide`, no `axiom`, no `unsafe`, and no added assumptions;
each finite claim is discharged by the kernel via `decide`. To confirm the axiom
footprint directly:

```bash
lake env lean verification/axioms.lean
```

See [`verification/`](verification/) for the recorded outputs and an independent
Python cross-check of the same construction.

## Source and attribution

* Ruiliang Li, *On an Erdős–Lovász problem: 3-critical 3-graphs of minimum degree 7*,
  arXiv:[2512.24850](https://arxiv.org/abs/2512.24850) (2025).
  The edge set is transcribed from Appendix A and the certificates from Appendix B,
  with the paper's 1-indexed vertices relabelled to `Fin 9`.
* The mathematical result — the construction and the proof that it works — is the
  author's. This repository contributes the Lean formalization and its verification.
