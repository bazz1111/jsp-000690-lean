/-
  JSP-000690 — a 3-uniform 3-chromatic-critical hypergraph with minimum degree 7.

  The problem bank entry asks whether there exists a 3-uniform hypergraph that is
  critical with respect to weak vertex-colourings and has minimum degree at least 7.
  The explicit 9-vertex example below is the chromatic-interpretation construction of

      Ruiliang Li, "On an Erdős--Lovász problem: 3-critical 3-graphs of minimum
      degree 7", arXiv:2512.24850 (2025),

  transcribed from Appendix A (edge set) and Appendix B (certificates).  Every
  finite claim is discharged by kernel reduction: the file contains no `sorry`, no
  `admit`, no `native_decide`, no `axiom` and no added assumptions, and it uses
  neither Mathlib nor Batteries.
-/

namespace Jsp000690

-- The `decide` proofs below reduce all 512 colourings of the nine vertices, which
-- exceeds the default elaborator recursion depth.
set_option maxRecDepth 4000000

/-- The nine vertices. -/
abbrev V := Fin 9

/-- An edge is a list of vertices. -/
abbrev Edge := List V

/-- A hypergraph is a list of edges. -/
abbrev HGraph := List Edge

/-- The vertex set. -/
def verts : List V := List.finRange 9

/-- The 22-edge 3-uniform hypergraph, arXiv:2512.24850 Appendix A.

Vertex `k` here is vertex `k + 1` in the paper. -/
def edges : HGraph :=
  [
    [0, 1, 2], [0, 1, 8], [0, 2, 7], [0, 3, 5], [0, 3, 7], [0, 3, 8],
    [0, 4, 6], [0, 4, 7], [0, 4, 8], [0, 5, 6], [1, 2, 5], [1, 2, 6],
    [1, 3, 8], [1, 4, 8], [1, 5, 6], [2, 3, 7], [2, 4, 7], [2, 5, 6],
    [3, 5, 7], [3, 5, 8], [4, 6, 7], [4, 6, 8],
  ]

/-- `nodup e` is true when `e` has no repeated vertex. -/
def nodup (e : Edge) : Bool :=
  e.all (fun v => (e.filter (fun w => w == v)).length == 1)

/-- `isMono e c` is true when every vertex of `e` has the same colour under `c`. -/
def isMono (e : Edge) (c : V → Bool) : Bool :=
  e.all c || e.all (fun v => !(c v))

/-- `isProper es c` is true when `c` leaves no edge of `es` monochromatic. -/
def isProper (es : HGraph) (c : V → Bool) : Bool :=
  es.all (fun e => !(isMono e c))

/-- `isProperExcept es c e` is true when `c` leaves no edge of `es` monochromatic
apart from possibly `e`. -/
def isProperExcept (es : HGraph) (c : V → Bool) (e : Edge) : Bool :=
  es.all (fun f => !(isMono f c) || f == e)

/-- The colouring given by the low nine bits of `n`. -/
def coloringOf (n : Nat) : V → Bool :=
  fun i => (n / 2 ^ i.val) % 2 == 1

/-- All `2 ^ 9 = 512` colourings of the nine vertices. -/
def allColorings : List (V → Bool) :=
  (List.range 512).map coloringOf

/-- The explicit proper 3-colouring `[0, 0, 1, 0, 0, 1, 2, 1, 1]`, indexed by `Fin 9`.

It is the first such colouring in lexicographic order, canonicalised so that
colours appear in order of first use. -/
def color3 : V → Fin 3 :=
  fun v =>
    match v.val with
    | 2 | 5 | 7 | 8 => 1
    | 6 => 2
    | _ => 0

/-- `isMono3 e c` is true when every vertex of `e` has the same colour under the
3-colouring `c`. -/
def isMono3 (e : Edge) (c : V → Fin 3) : Bool :=
  match e with
  | a :: rest => rest.all (fun v => c v == c a)
  | [] => true

/-- `isProper3 es c` is true when the 3-colouring `c` leaves no edge of `es`
monochromatic. -/
def isProper3 (es : HGraph) (c : V → Fin 3) : Bool :=
  es.all (fun e => !(isMono3 e c))

/-- The blue sets of the edge-deletion certificates, Appendix B.1. -/
def edgeCerts : List (Edge × List V) :=
  [
    ([0, 1, 2], [5, 6, 7, 8]),
    ([0, 1, 8], [2, 3, 4, 5]),
    ([0, 2, 7], [1, 3, 4, 5]),
    ([0, 3, 5], [1, 6, 7, 8]),
    ([0, 3, 7], [2, 4, 5, 8]),
    ([0, 3, 8], [1, 4, 5, 7]),
    ([0, 4, 6], [1, 5, 7, 8]),
    ([0, 4, 7], [2, 3, 6, 8]),
    ([0, 4, 8], [1, 3, 6, 7]),
    ([0, 5, 6], [1, 2, 3, 4]),
    ([1, 2, 5], [0, 6, 7, 8]),
    ([1, 2, 6], [0, 5, 7, 8]),
    ([1, 3, 8], [0, 2, 4, 5]),
    ([1, 4, 8], [0, 2, 3, 6]),
    ([1, 5, 6], [0, 2, 3, 4]),
    ([2, 3, 7], [0, 1, 4, 5]),
    ([2, 4, 7], [0, 1, 3, 6]),
    ([2, 5, 6], [0, 1, 3, 4]),
    ([3, 5, 7], [0, 2, 6, 8]),
    ([3, 5, 8], [0, 1, 6, 7]),
    ([4, 6, 7], [0, 2, 5, 8]),
    ([4, 6, 8], [0, 1, 5, 7]),
  ]

/-- The blue sets of the vertex-deletion certificates, Appendix B.2. -/
def vertexCerts : List (V × List V) :=
  [
    (0, [1, 2, 3, 4]),
    (1, [0, 2, 3, 4]),
    (2, [0, 1, 3, 4]),
    (3, [0, 1, 4, 5]),
    (4, [0, 1, 3, 6]),
    (5, [0, 1, 3, 4]),
    (6, [0, 1, 3, 4]),
    (7, [0, 1, 3, 6]),
    (8, [0, 1, 5, 7]),
  ]

/-- The 2-colouring whose blue set is `B`. -/
def colorOfSet (B : List V) : V → Bool :=
  fun v => B.contains v

/-! ### The verified properties -/

/-- The hypergraph is 3-uniform: every edge has three pairwise distinct vertices. -/
theorem three_uniform :
    edges.all (fun e => e.length == 3 && nodup e) = true := by
  decide

/-- Every vertex lies in at least seven edges. -/
theorem min_degree_at_least_seven :
    verts.all (fun v => decide (7 ≤ (edges.filter (fun e => e.contains v)).length)) = true := by
  decide

/-- Vertex `0` has degree 10 and every other vertex has degree exactly 7, so the
minimum degree is exactly 7. -/
theorem degrees :
    verts.map (fun v => (edges.filter (fun e => e.contains v)).length) = [10, 7, 7, 7, 7, 7, 7, 7, 7] := by
  decide

/-- The explicit 3-colouring is proper, so the chromatic number is at most 3. -/
theorem three_colorable :
    isProper3 edges color3 = true := by
  decide

/-- No 2-colouring is proper, so the chromatic number is at least 3. -/
theorem not_two_colorable :
    allColorings.all (fun c => !(isProper edges c)) = true := by
  decide

/-- Deleting any single edge makes the hypergraph 2-colourable. -/
theorem edge_critical :
    edges.all (fun e => allColorings.any (fun c => isProperExcept edges c e)) = true := by
  decide

/-- Deleting any single vertex makes the hypergraph 2-colourable. -/
theorem vertex_critical :
    verts.all (fun v =>
      allColorings.any (fun c => isProper (edges.filter (fun e => !(e.contains v))) c)) = true := by
  decide

/-! ### The certificates of Appendix B -/

/-- Each edge-deletion certificate is a colouring whose only monochromatic edge is
the edge it certifies. -/
theorem edge_certs_valid :
    edgeCerts.all (fun p =>
      (edges.filter (fun f => isMono f (colorOfSet p.2))) == [p.1]) = true := by
  decide

/-- Each vertex-deletion certificate properly 2-colours the hypergraph with that
vertex deleted. -/
theorem vertex_certs_valid :
    vertexCerts.all (fun p =>
      isProper (edges.filter (fun e => !(e.contains p.1))) (colorOfSet p.2)) = true := by
  decide

/-! ### The result -/

/-- A hypergraph is **3-chromatic-critical** when its chromatic number is exactly 3
and deleting any single edge or any single vertex makes it 2-colourable. -/
structure IsThreeChromaticCritical (H : HGraph) : Prop where
  /-- Every edge has three pairwise distinct vertices. -/
  uniform : H.all (fun e => e.length == 3 && nodup e) = true
  /-- Some 3-colouring is proper. -/
  three_colorable : ∃ c : V → Fin 3, isProper3 H c = true
  /-- No 2-colouring is proper. -/
  not_two_colorable : allColorings.all (fun c => !(isProper H c)) = true
  /-- Deleting any edge restores 2-colourability. -/
  edge_critical : H.all (fun e => allColorings.any (fun c => isProperExcept H c e)) = true
  /-- Deleting any vertex restores 2-colourability. -/
  vertex_critical :
    verts.all (fun v =>
      allColorings.any (fun c => isProper (H.filter (fun e => !(e.contains v))) c)) = true

/-- Every vertex of `H` lies in at least `d` edges. -/
def MinDegreeAtLeast (H : HGraph) (d : Nat) : Prop :=
  verts.all (fun v => decide (d ≤ (H.filter (fun e => e.contains v)).length)) = true

/-- **JSP-000690.** There exists a 3-uniform, 3-chromatic-critical hypergraph in
which every vertex has degree at least 7.

This answers the chromatic interpretation of the Erdős--Lovász question recorded as
JSP-000690 in the problem bank. -/
theorem exists_critical_min_degree_seven :
    ∃ H : HGraph, IsThreeChromaticCritical H ∧ MinDegreeAtLeast H 7 :=
  ⟨edges,
   ⟨three_uniform, ⟨color3, three_colorable⟩, not_two_colorable, edge_critical, vertex_critical⟩,
   min_degree_at_least_seven⟩

end Jsp000690
