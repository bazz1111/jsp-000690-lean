"""Independent verification of the Li (2025) 3-critical 3-graph on 9 vertices.

Re-derived from arXiv:2512.24850 appendices A and B.  Checks the five claims the
paper makes, plus the two certificate tables, using an independently written
brute force rather than the author's script.

Read-only: prints results, writes nothing.
"""
from itertools import combinations, product

V = list(range(1, 10))

E = [
    (1, 2, 3), (1, 2, 9), (1, 3, 8), (1, 4, 6), (1, 4, 8), (1, 4, 9),
    (1, 5, 7), (1, 5, 8), (1, 5, 9), (1, 6, 7),
    (2, 3, 6), (2, 3, 7), (2, 4, 9), (2, 5, 9), (2, 6, 7),
    (3, 4, 8), (3, 5, 8), (3, 6, 7),
    (4, 6, 8), (4, 6, 9),
    (5, 7, 8), (5, 7, 9),
]

EDGE_CERTS = {
    (1, 2, 3): {6, 7, 8, 9}, (1, 2, 9): {3, 4, 5, 6}, (1, 3, 8): {2, 4, 5, 6},
    (1, 4, 6): {2, 7, 8, 9}, (1, 4, 8): {3, 5, 6, 9}, (1, 4, 9): {2, 5, 6, 8},
    (1, 5, 7): {2, 6, 8, 9}, (1, 5, 8): {3, 4, 7, 9}, (1, 5, 9): {2, 4, 7, 8},
    (1, 6, 7): {2, 3, 4, 5}, (2, 3, 6): {1, 7, 8, 9}, (2, 3, 7): {1, 6, 8, 9},
    (2, 4, 9): {1, 3, 5, 6}, (2, 5, 9): {1, 3, 4, 7}, (2, 6, 7): {1, 3, 4, 5},
    (3, 4, 8): {1, 2, 5, 6}, (3, 5, 8): {1, 2, 4, 7}, (3, 6, 7): {1, 2, 4, 5},
    (4, 6, 8): {1, 3, 7, 9}, (4, 6, 9): {1, 2, 7, 8}, (5, 7, 8): {1, 3, 6, 9},
    (5, 7, 9): {1, 2, 6, 8},
}

VERTEX_CERTS = {
    1: {2, 3, 4, 5}, 2: {1, 3, 4, 5}, 3: {1, 2, 4, 5}, 4: {1, 2, 5, 6},
    5: {1, 2, 4, 7}, 6: {1, 2, 4, 5}, 7: {1, 2, 4, 5}, 8: {1, 2, 4, 7},
    9: {1, 2, 6, 8},
}


def mono(edge, blue):
    return all(v in blue for v in edge) or all(v not in blue for v in edge)


def report(label, ok, extra=""):
    print(f"  [{'PASS' if ok else 'FAIL'}] {label}{('  ' + extra) if extra else ''}")
    return ok


results = []

print("=== structural facts ===")
results.append(report("|V| = 9", len(V) == 9))
results.append(report("|E| = 22", len(E) == 22))
results.append(report("all edges are 3-element sets of distinct vertices",
                      all(len(set(e)) == 3 and set(e) <= set(V) for e in E)))
results.append(report("no duplicate edges", len(set(E)) == len(E)))

deg = {v: sum(1 for e in E if v in e) for v in V}
print(f"  degrees: {deg}")
results.append(report("delta(H) = 7", min(deg.values()) == 7, f"min={min(deg.values())} max={max(deg.values())}"))

print("\n=== H is not 2-colourable (chi(H) = 3) ===")
bad = []
for bits in product([0, 1], repeat=9):
    blue = {v for v, b in zip(V, bits) if b}
    if not any(mono(e, blue) for e in E):
        bad.append(blue)
results.append(report("no proper 2-colouring of H exists", not bad, f"found {len(bad)}"))

print("\n=== edge-criticality ===")
fails = []
for e in E:
    rest = [f for f in E if f != e]
    found = None
    for bits in product([0, 1], repeat=9):
        blue = {v for v, b in zip(V, bits) if b}
        if not any(mono(f, blue) for f in rest):
            found = blue
            break
    if found is None:
        fails.append(e)
results.append(report("H - e is 2-colourable for every edge e", not fails, f"failures={fails}"))

print("\n=== vertex-criticality ===")
fails = []
for v in V:
    keep = [u for u in V if u != v]
    rest = [e for e in E if set(e) <= set(keep)]
    found = None
    for bits in product([0, 1], repeat=len(keep)):
        blue = {u for u, b in zip(keep, bits) if b}
        if not any(mono(e, blue) for e in rest):
            found = blue
            break
    if found is None:
        fails.append(v)
results.append(report("H - v is 2-colourable for every vertex v", not fails, f"failures={fails}"))

print("\n=== Table 1: edge-deletion certificates (e is the UNIQUE monochromatic edge) ===")
results.append(report("certificate table covers every edge", set(EDGE_CERTS) == set(E)))
fails = []
for e, B in EDGE_CERTS.items():
    monos = [f for f in E if mono(f, B)]
    if monos != [e]:
        fails.append((e, monos))
results.append(report("each certificate makes exactly its own edge monochromatic",
                      not fails, f"failures={fails[:3]}"))
results.append(report("every certificate is a subset of V", all(B <= set(V) for B in EDGE_CERTS.values())))

print("\n=== Table 2: vertex-deletion certificates (proper 2-colouring of H - v) ===")
results.append(report("certificate table covers every vertex", set(VERTEX_CERTS) == set(V)))
fails = []
for v, B in VERTEX_CERTS.items():
    if v in B:
        fails.append((v, "colour set contains the deleted vertex"))
        continue
    rest = [e for e in E if set(e) <= set(V) - {v}]
    if any(mono(e, B) for e in rest):
        fails.append((v, "monochromatic edge remains"))
results.append(report("each certificate properly 2-colours H - v", not fails, f"failures={fails}"))

print("\n=== overall ===")
print(f"  {sum(results)}/{len(results)} checks passed")
print("  CONSTRUCTION VERIFIED" if all(results) else "  CONSTRUCTION REJECTED")
