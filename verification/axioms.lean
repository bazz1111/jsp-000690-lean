/-
  Axiom audit.  Every listed theorem must report a subset of the Lean standard
  axioms {propext, Classical.choice, Quot.sound}.  The expected result here is
  [propext] for all ten theorems, which is what `decide` contributes when it turns
  a `Bool` equality into a proposition.  No other axiom, and no `sorryAx`, may
  appear.

  Run with:  lake env lean verification/axioms.lean
-/
import Jsp000690

#print axioms Jsp000690.three_uniform
#print axioms Jsp000690.min_degree_at_least_seven
#print axioms Jsp000690.degrees
#print axioms Jsp000690.not_two_colorable
#print axioms Jsp000690.three_colorable
#print axioms Jsp000690.edge_critical
#print axioms Jsp000690.vertex_critical
#print axioms Jsp000690.edge_certs_valid
#print axioms Jsp000690.vertex_certs_valid
#print axioms Jsp000690.exists_critical_min_degree_seven
