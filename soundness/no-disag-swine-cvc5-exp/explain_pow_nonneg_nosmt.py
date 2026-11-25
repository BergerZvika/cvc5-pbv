#!/usr/bin/env python3
"""
Explain why every exponent t in (** s t) of a QF_EIA benchmark is non-negative,
using only the benchmark's own assertions -- WITHOUT calling an SMT solver.

Lets are expanded, top-level asserts are split into conjuncts, and every atomic
comparison is normalised to  p >= 0  or  p = 0  (p a polynomial whose monomials,
including each (** s e) term, are integer-valued atoms; integer tightening is
applied).  For every distinct exponent t, in this order:

  1. constant exponent                 -> decided directly
  2. bound propagation + interval      -> t >= 0 from derived variable bounds,
     evaluation                           handling * (squares are >= 0), div by a
                                          positive constant, and
                                          b^e >= 1 for numeral b > 0, e >= 0
  3. Farkas certificate (exact simplex)-> t = sum l_i*e_i + d, l_i >= 0, d > -1
  4. if the asserts used by 2/3 are contradictory on their own (or nothing was
     found but propagation hit a contradiction) -> "proved (vacuous)"
  5. otherwise "NOT PROVED"; for small benchmarks a brute-force search looks for
     an integer point of the linear asserts with t < 0 ("NOT IMPLIED").

The assertions used by the successful step are listed as the explanation.

Usage:
  explain_pow_nonneg_nosmt.py FILE_OR_DIR [...]  [--json] [--summary] [--out DIR]
"""

import argparse
import json
import os
import sys
from fractions import Fraction

import re
from itertools import product
from math import ceil, floor, gcd

# --------------------------------------------------------------------------
# S-expression parsing
# --------------------------------------------------------------------------


def tokenize(text):
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c.isspace():
            i += 1
        elif c == ';':
            while i < n and text[i] != '\n':
                i += 1
        elif c in '()':
            yield c
            i += 1
        elif c == '|':
            j = text.index('|', i + 1)
            yield text[i:j + 1]
            i = j + 1
        elif c == '"':
            j = i + 1
            while True:
                j = text.index('"', j)
                if j + 1 < n and text[j + 1] == '"':
                    j += 2
                    continue
                break
            yield text[i:j + 1]
            i = j + 1
        else:
            j = i
            while j < n and not text[j].isspace() and text[j] not in '();':
                j += 1
            yield text[i:j]
            i = j


def parse_sexprs(text):
    stack, out = [[]], None
    for tok in tokenize(text):
        if tok == '(':
            stack.append([])
        elif tok == ')':
            e = tuple(stack.pop())
            stack[-1].append(e)
        else:
            stack[-1].append(tok)
    return stack[0]


def to_str(e):
    if isinstance(e, str):
        return e
    return '(' + ' '.join(to_str(x) for x in e) + ')'


def expand_lets(e, env=None):
    env = env or {}
    if isinstance(e, str):
        return env.get(e, e)
    if e and e[0] == 'let':
        new_env = dict(env)
        for name, val in e[1]:
            new_env[name] = expand_lets(val, env)  # parallel let
        return expand_lets(e[2], new_env)
    return tuple(expand_lets(x, env) for x in e)


def is_num(s):
    return isinstance(s, str) and s.isdigit()


def const_value(e):
    """Integer value of a ground numeral expression, else None."""
    if is_num(e):
        return int(e)
    if isinstance(e, tuple) and e and e[0] == '-' and len(e) == 2:
        v = const_value(e[1])
        return None if v is None else -v
    return None


# --------------------------------------------------------------------------
# Polynomials (for normalisation / pretty printing)
# --------------------------------------------------------------------------
# polynomial: dict  monomial(tuple of sorted atom names) -> Fraction


class NonPoly(Exception):
    pass


def p_add(a, b, k=1):
    r = dict(a)
    for m, c in b.items():
        r[m] = r.get(m, 0) + k * c
        if r[m] == 0:
            del r[m]
    return r


def p_mul(a, b):
    r = {}
    for m1, c1 in a.items():
        for m2, c2 in b.items():
            m = tuple(sorted(m1 + m2))
            r[m] = r.get(m, 0) + c1 * c2
            if r[m] == 0:
                del r[m]
    return r


def poly_of(e, pow_name):
    if isinstance(e, str):
        if is_num(e):
            v = Fraction(int(e))
            return {(): v} if v else {}
        return {(e,): Fraction(1)}
    op, args = e[0], e[1:]
    if op == '+':
        r = {}
        for a in args:
            r = p_add(r, poly_of(a, pow_name))
        return r
    if op == '-':
        if len(args) == 1:
            return p_add({}, poly_of(args[0], pow_name), -1)
        r = poly_of(args[0], pow_name)
        for a in args[1:]:
            r = p_add(r, poly_of(a, pow_name), -1)
        return r
    if op == '*':
        r = {(): Fraction(1)}
        for a in args:
            r = p_mul(r, poly_of(a, pow_name))
        return r
    if op == '**':
        return {(pow_name(e),): Fraction(1)}
    raise NonPoly(op)


def fmt_coef(c):
    return str(c.numerator) if c.denominator == 1 else f'{c.numerator}/{c.denominator}'


def poly_str(p):
    if not p:
        return '0'
    terms = sorted(p.items(), key=lambda kv: (len(kv[0]) == 0, kv[0]))
    out = []
    for i, (m, c) in enumerate(terms):
        sign = '-' if c < 0 else '+'
        a = abs(c)
        mono = '*'.join(m)
        if not m:
            body = fmt_coef(a)
        elif a == 1:
            body = mono
        else:
            body = f'{fmt_coef(a)}*{mono}'
        if i == 0:
            out.append(('-' if sign == '-' else '') + body)
        else:
            out.append(f' {sign} {body}')
    return ''.join(out)


# --------------------------------------------------------------------------
# Constraints:  poly >= 0  or  poly = 0   (monomials are integer-valued atoms)
# --------------------------------------------------------------------------

INF = float('inf')
REL = {'<', '<=', '>', '>=', '='}


def tighten(kind, p):
    """Integer tightening: divide by the gcd of the coefficients, floor the constant."""
    coefs = [c for m, c in p.items() if m]
    if not coefs:
        return kind, p
    den = 1
    for c in list(p.values()):
        den = den * c.denominator // gcd(den, c.denominator)
    p = {m: c * den for m, c in p.items()}
    g = 0
    for m, c in p.items():
        if m:
            g = gcd(g, int(c))
    c0 = p.get((), Fraction(0))
    if kind == '=' and c0 % g != 0:
        return '=', {(): Fraction(1)}                   # unsatisfiable: 1 = 0
    q = {m: c / g for m, c in p.items() if m}
    k0 = Fraction(floor(c0 / g)) if kind == '>=' else c0 / g
    if k0:
        q[()] = k0
    return kind, q


class Benchmark:
    def __init__(self, path):
        self.path = path
        with open(path) as f:
            cmds = parse_sexprs(f.read())
        self.vars = []
        self.conjuncts = []          # [(label, sexpr)]
        self.pows = {}               # sexpr -> name
        self.pow_list = []           # [(name, sexpr)]
        a_idx = 0
        for c in cmds:
            if not isinstance(c, tuple) or not c:
                continue
            if c[0] == 'declare-fun' and c[2] == ():
                self.vars.append(c[1])
            elif c[0] == 'declare-const':
                self.vars.append(c[1])
            elif c[0] == 'assert':
                a_idx += 1
                parts = self._split_and(expand_lets(c[1]))
                for j, p in enumerate(parts, 1):
                    lab = f'A{a_idx}' if len(parts) == 1 else f'A{a_idx}.{j}'
                    self.conjuncts.append((lab, p))
        for _, p in self.conjuncts:
            self._collect_pows(p)
        self.text = {lab: to_str(p) for lab, p in self.conjuncts}
        self.cons = []               # [(label, kind, poly)]
        for lab, p in self.conjuncts:
            for kind, poly in self._constraints(p):
                self.cons.append((lab,) + tighten(kind, poly))

    def _split_and(self, e):
        if isinstance(e, tuple) and e and e[0] == 'and':
            r = []
            for x in e[1:]:
                r.extend(self._split_and(x))
            return r
        return [e]

    def _collect_pows(self, e):
        if isinstance(e, tuple):
            for x in e[1:]:
                self._collect_pows(x)
            if e[0] == '**' and e not in self.pows:
                name = f'pow{len(self.pow_list)}'
                self.pows[e] = name
                self.pow_list.append((name, e))

    def pow_name(self, e):
        return self.pows[e]

    def _constraints(self, e):
        """Linear (in monomials) constraints of an atomic conjunct; [] if not atomic."""
        neg = False
        while isinstance(e, tuple) and e[0] == 'not':
            neg, e = not neg, e[1]
        if e == 'false' and not neg:
            return [('=', {(): Fraction(1)})]
        if not (isinstance(e, tuple) and e[0] in REL and len(e) >= 3):
            return []
        op = e[0]
        if neg:
            op = {'<': '>=', '<=': '>', '>': '<=', '>=': '<', '=': None}[op]
            if op is None or len(e) != 3:
                return []
        try:
            ps = [poly_of(x, self.pow_name) for x in e[1:]]
        except NonPoly:
            return []
        one = {(): Fraction(1)}
        out = []
        for l, r in zip(ps, ps[1:]):
            d = p_add(l, r, -1)                          # l - r
            if op == '>=':
                out.append(('>=', d))
            elif op == '>':
                out.append(('>=', p_add(d, one, -1)))
            elif op == '<=':
                out.append(('>=', p_add({}, d, -1)))
            elif op == '<':
                out.append(('>=', p_add(p_add({}, d, -1), one, -1)))
            else:
                out.append(('=', d))
        return out


# --------------------------------------------------------------------------
# Intervals with reasons
# --------------------------------------------------------------------------
# bound: (lo, hi, reasons) ; lo/hi are Fraction or -INF/INF ; reasons frozenset


def i_mul(a, b):
    def m(x, y):
        if x == 0 or y == 0:
            return 0
        return x * y
    vs = [m(x, y) for x in (a[0], a[1]) for y in (b[0], b[1])]
    return (min(vs), max(vs), a[2] | b[2])


def i_pow(a, k):
    """a^k for a numeral k >= 0."""
    if k == 0:
        return (Fraction(1), Fraction(1), frozenset())
    lo, hi, rs = a
    if k % 2 == 1 or lo >= 0:
        return (pw(lo, k), pw(hi, k), rs)
    if hi <= 0:
        return (pw(hi, k), pw(lo, k), rs)
    return (Fraction(0), max(pw(lo, k), pw(hi, k)), rs)


def pw(x, k):
    if x in (INF, -INF):
        return INF if (x > 0 or k % 2 == 0) else -INF
    return x ** k


TOP = (-INF, INF, frozenset())


class Bounds:
    """Bound propagation over the linear constraints (monomials are atoms)."""

    def __init__(self, cons, rounds=30):
        self.lo, self.hi = {}, {}            # atom -> (value, reasons)
        self.conflict = None
        self.cons = cons
        for _ in range(rounds):
            changed = False
            for lab, kind, p in cons:
                changed |= self._propagate(lab, kind, p)
                if self.conflict is not None:
                    return
            changed |= self._monomials()
            if self.conflict is not None or not changed:
                return

    def get(self, mono):
        lo, lr = self.lo.get(mono, (-INF, frozenset()))
        hi, hr = self.hi.get(mono, (INF, frozenset()))
        return (lo, hi, lr | hr)

    def lower(self, mono):
        return self.lo.get(mono, (-INF, frozenset()))

    def upper(self, mono):
        return self.hi.get(mono, (INF, frozenset()))

    def _set(self, mono, side, val, rs):
        if side == 'lo':
            if val == -INF:
                return False
            val = Fraction(ceil(val))
            if val <= self.lower(mono)[0]:
                return False
            self.lo[mono] = (val, rs)
        else:
            if val == INF:
                return False
            val = Fraction(floor(val))
            if val >= self.upper(mono)[0]:
                return False
            self.hi[mono] = (val, rs)
        lo, lr = self.lower(mono)
        hi, hr = self.upper(mono)
        if lo > hi:
            self.conflict = lr | hr
        return True

    def _propagate(self, lab, kind, p):
        c0 = p.get((), Fraction(0))
        terms = [(m, c) for m, c in p.items() if m]
        if not terms:
            bad = c0 < 0 if kind == '>=' else c0 != 0
            if bad:
                self.conflict = frozenset([lab])
            return False
        changed = False
        # sum c_m * m + c0 >= 0  (and <= 0 for equalities)
        for sign in ((1,) if kind == '>=' else (1, -1)):
            # max of the other terms, with reasons
            contrib = []
            for m, c in terms:
                c = c * sign
                if c > 0:
                    v, r = self.upper(m)
                else:
                    v, r = self.lower(m)
                contrib.append((m, c, v, r))
            infs = [x for x in contrib if x[2] in (INF, -INF)]
            if len(infs) > 1:
                continue
            for m, c, v, r in contrib:
                if infs and infs[0][0] != m:
                    continue
                rest = c0 * sign
                rs = frozenset([lab])
                for m2, c2, v2, r2 in contrib:
                    if m2 is m:
                        continue
                    rest += c2 * v2
                    rs |= r2
                # c*m >= -rest
                if c > 0:
                    changed |= self._set(m, 'lo', -rest / c, rs)
                else:
                    changed |= self._set(m, 'hi', -rest / c, rs)
                if self.conflict is not None:
                    return changed
        return changed

    def _monomials(self):
        changed = False
        monos = {m for _, _, p in self.cons for m in p if len(m) > 1}
        for m in monos:
            iv = mono_interval(m, self)
            changed |= self._set(m, 'lo', iv[0], iv[2])
            changed |= self._set(m, 'hi', iv[1], iv[2])
            if self.conflict is not None:
                break
        return changed


def mono_interval(m, bounds):
    iv = (Fraction(1), Fraction(1), frozenset())
    for atom in sorted(set(m)):
        iv = i_mul(iv, i_pow(bounds.get((atom,)), m.count(atom)))
    return iv


# --------------------------------------------------------------------------
# Interval evaluation of an exponent expression
# --------------------------------------------------------------------------


def eval_interval(e, bench, bounds, depth=0):
    if isinstance(e, str):
        if is_num(e):
            v = Fraction(int(e))
            return (v, v, frozenset())
        return bounds.get((e,))
    op, args = e[0], e[1:]
    if op == '**':
        name = bench.pow_name(e)
        own = bounds.get((name,))
        s, t = args
        k = const_value(t)
        b = const_value(s)
        derived = TOP
        if k is not None and k >= 0:
            derived = i_pow(eval_interval(s, bench, bounds, depth + 1), k)
        elif b is not None and b > 0 and depth < 10:
            te = eval_interval(t, bench, bounds, depth + 1)
            if te[0] >= 0:
                derived = (Fraction(1), INF, te[2])        # b^t >= 1 for b > 0, t >= 0
        return intersect(own, derived)
    ivs = [eval_interval(x, bench, bounds, depth + 1) for x in args]
    if op == '+':
        r = (Fraction(0), Fraction(0), frozenset())
        for x in ivs:
            r = (r[0] + x[0], r[1] + x[1], r[2] | x[2])
        return r
    if op == '-':
        if len(ivs) == 1:
            return (-ivs[0][1], -ivs[0][0], ivs[0][2])
        r = ivs[0]
        for x in ivs[1:]:
            r = (r[0] - x[1], r[1] - x[0], r[2] | x[2])
        return r
    if op == '*':
        # identical factors are powers, so (* n n) >= 0
        r = (Fraction(1), Fraction(1), frozenset())
        seen = []
        for a in args:
            if a not in seen:
                seen.append(a)
        for a in seen:
            r = i_mul(r, i_pow(eval_interval(a, bench, bounds, depth + 1), args.count(a)))
        return r
    if op == 'div' and len(ivs) == 2:
        k = const_value(args[1])
        if k is not None and k > 0:
            lo, hi, rs = ivs[0]
            return (Fraction(floor(lo / k)) if lo != -INF else -INF,
                    Fraction(floor(hi / k)) if hi != INF else INF, rs)
    if op == 'abs':
        lo, hi, rs = ivs[0]
        if lo >= 0:
            return ivs[0]
        if hi <= 0:
            return (-hi, -lo, rs)
        return (Fraction(0), max(-lo, hi), rs)
    if op == 'ite':
        c, x, y = ivs
        return (min(x[0], y[0]), max(x[1], y[1]), x[2] | y[2])
    return TOP


def intersect(a, b):
    lo = a[0] if a[0] >= b[0] else b[0]
    hi = a[1] if a[1] <= b[1] else b[1]
    rs = (a[2] if a[0] >= b[0] else b[2]) | (a[2] if a[1] <= b[1] else b[2])
    return (lo, hi, rs)


# --------------------------------------------------------------------------
# Farkas certificates via exact simplex
# --------------------------------------------------------------------------


def simplex_min(A, b, c):
    """min c.x  s.t.  A x = b, x >= 0  (exact, Bland's rule).
    Returns ('optimal', value, x) | ('infeasible',) | ('unbounded',)."""
    m, n = len(A), len(c)
    A = [row[:] for row in A]
    b = b[:]
    for i in range(m):
        if b[i] < 0:
            A[i] = [-v for v in A[i]]
            b[i] = -b[i]
    # tableau with artificials n..n+m-1
    T = [A[i] + [Fraction(int(i == j)) for j in range(m)] + [b[i]] for i in range(m)]
    basis = [n + i for i in range(m)]

    def pivot(r, col):
        pv = T[r][col]
        T[r] = [v / pv for v in T[r]]
        for i in range(m):
            if i != r and T[i][col] != 0:
                f = T[i][col]
                Ti, Tr = T[i], T[r]
                T[i] = [vi - f * vr for vi, vr in zip(Ti, Tr)]
        basis[r] = col

    def run(cost, allowed):
        while True:
            # reduced costs
            best = None
            for j in range(allowed):
                if j in basis:
                    continue
                rc = cost[j] - sum(cost[basis[i]] * T[i][j] for i in range(m))
                if rc < 0:
                    best = j
                    break
            if best is None:
                return 'optimal'
            rows = [(T[i][-1] / T[i][best], basis[i], i) for i in range(m) if T[i][best] > 0]
            if not rows:
                return 'unbounded'
            pivot(min(rows)[2], best)

    cost1 = [Fraction(0)] * n + [Fraction(1)] * m
    run(cost1, n + m)
    if sum(T[i][-1] for i in range(m) if basis[i] >= n) > 0:
        return ('infeasible',)
    # drive remaining artificials out of the basis
    for i in range(m):
        if basis[i] >= n:
            for j in range(n):
                if T[i][j] != 0 and j not in basis:
                    pivot(i, j)
                    break
    keep = [i for i in range(m) if basis[i] < n]
    T = [T[i] for i in keep]
    basis = [basis[i] for i in keep]
    m = len(T)
    T = [row[:n] + [row[-1]] for row in T]
    status = run(list(c), n)
    if status == 'unbounded':
        return ('unbounded',)
    x = [Fraction(0)] * n
    for i in range(m):
        x[basis[i]] = T[i][-1]
    return ('optimal', sum(ci * xi for ci, xi in zip(c, x)), x)


def relevant(cons, monos, limit=400):
    """Constraints connected (through shared atoms) to the given monomials."""
    atoms = {a for m in monos for a in m}
    chosen, rest = [], list(cons)
    grew = True
    while grew and len(chosen) < limit:
        grew = False
        nxt = []
        for c in rest:
            ca = {a for m in c[2] for a in m}
            if ca & atoms:
                chosen.append(c)
                atoms |= ca
                grew = True
            else:
                nxt.append(c)
        rest = nxt
    return chosen[:limit]


def farkas(t_poly, cons):
    """Find t = sum l_i*e_i + sum u_j*f_j + d  with l_i >= 0, d > -1.
    Returns the labels used, or None."""
    cols = []                                  # (label, sign, poly)
    for lab, kind, p in cons:
        cols.append((lab, 1, p))
        if kind == '=':
            cols.append((lab, -1, p))
    monos = sorted({m for _, _, p in cols for m in p if m} | {m for m in t_poly if m})
    if not cols:
        return None
    A = [[s * p.get(m, Fraction(0)) for _, s, p in cols] for m in monos]
    b = [t_poly.get(m, Fraction(0)) for m in monos]
    c = [s * p.get((), Fraction(0)) for _, s, p in cols]
    if not A:          # only constants involved
        A, b = [[Fraction(0)] * len(cols)], [Fraction(0)]
    r = simplex_min(A, b, c)
    if r[0] == 'infeasible':
        return None
    if r[0] == 'unbounded':
        return None                            # constraints contradictory: see contradiction()
    # d = t0 - sum(...)  is maximal when sum(...) is minimal
    d = t_poly.get((), Fraction(0)) - r[1]
    if d <= -1:
        return None
    return sorted({cols[j][0] for j, v in enumerate(r[2]) if v != 0})


def contradiction(cons):
    """Farkas proof of infeasibility: sum l_i*e_i + sum u_j*f_j = -1 (all
    monomials cancel), l_i >= 0.  Returns the labels used, or None."""
    cols = []
    for lab, kind, p in cons:
        cols.append((lab, 1, p))
        if kind == '=':
            cols.append((lab, -1, p))
    if not cols:
        return None
    monos = sorted({m for _, _, p in cols for m in p if m})
    A = [[s * p.get(m, Fraction(0)) for _, s, p in cols] for m in monos]
    A.append([s * p.get((), Fraction(0)) for _, s, p in cols])
    b = [Fraction(0)] * len(monos) + [Fraction(-1)]
    r = simplex_min(A, b, [Fraction(0)] * len(cols))
    if r[0] != 'optimal':
        return None
    return frozenset(cols[j][0] for j, v in enumerate(r[2]) if v != 0)


# --------------------------------------------------------------------------
# Explanation
# --------------------------------------------------------------------------


def label_key(lab):
    return tuple(int(x) for x in lab[1:].split('.'))


def find_witness(bench, t_poly, max_vars=4, rng=10):
    """Small integer point satisfying every linear assert (over plain variables) and t < 0."""
    if t_poly is None or any(len(m) != 1 or m[0] not in bench.vars for m in t_poly if m):
        return None
    cons = [c for c in bench.cons if all(len(m) == 1 and m[0] in bench.vars for m in c[2] if m)]
    vs = sorted({m[0] for _, _, p in cons for m in p if m} | {m[0] for m in t_poly if m})
    if len(vs) > max_vars:
        return None

    def val(p, env):
        return sum(c * (env[m[0]] if m else 1) for m, c in p.items())
    for point in product(range(-rng, rng + 1), repeat=len(vs)):
        env = dict(zip(vs, point))
        if val(t_poly, env) >= 0:
            continue
        if all(val(p, env) >= 0 if k == '>=' else val(p, env) == 0 for _, k, p in cons):
            w = {v: str(env[v]) for v in vs}
            w['t'] = str(val(t_poly, env))
            return w
    return None


def explain(bench):
    results = []
    bounds = Bounds(bench.cons)
    conflict = bounds.conflict

    by_exp = {}
    for name, e in bench.pow_list:
        by_exp.setdefault(e[2], []).append((name, e))

    for t, occ in by_exp.items():
        res = {'exponent': to_str(t),
               'occurrences': [f'{n} := {to_str(e)}' for n, e in occ]}
        try:
            t_poly = poly_of(t, bench.pow_name)
        except NonPoly:
            t_poly = None
        res['exponent_normalized'] = poly_str(t_poly) if t_poly is not None else to_str(t)

        k = const_value(t)
        if k is not None:
            res['status'] = 'proved' if k >= 0 else 'NEGATIVE'
            res['reason'] = f'exponent is the constant {k}'
            results.append(res)
            continue

        # real proof first (bounds derived before a conflict are still valid)
        used = None
        iv = eval_interval(t, bench, bounds)
        if iv[0] >= 0:
            used = iv[2]
            res['status'] = 'proved'
            res['method'] = f'bound propagation: t >= {iv[0]}'
        elif t_poly is not None:
            fk = farkas(t_poly, relevant(bench.cons, list(t_poly)))
            if fk is not None:
                used = fk
                res['status'] = 'proved'
                res['method'] = 'linear combination of the asserts (Farkas)'
        bad = None
        if used is not None:
            # the used asserts may already be contradictory -> vacuous proof
            sub = [c for c in bench.cons if c[0] in used]
            bad = Bounds(sub).conflict
            if bad is None:
                bad = contradiction(sub)
        elif conflict is not None:
            bad = conflict
        elif t_poly is not None:
            bad = contradiction(relevant(bench.cons, list(t_poly)))
        if bad is not None:
            used = bad
            res['status'] = 'proved (vacuous)'
            res['reason'] = 'these assertions are contradictory on their own'
            res.pop('method', None)
        if used is None:
            res['status'] = 'NOT PROVED'
            w = find_witness(bench, t_poly)
            if w is not None:
                res['status'] = 'NOT IMPLIED'
                res['counterexample'] = w
        else:
            res['core'] = [{'label': lab, 'kind': 'assert', 'text': bench.text[lab]}
                           for lab in sorted(used, key=label_key)]
        results.append(res)
    return results


def render_text(path, results):
    out = [f'=== {path}']
    if not results:
        out.append('  (no ** terms)')
    n_ok = sum(r['status'] == 'proved' for r in results)
    out.append(f'  {len(results)} distinct exponent(s), {n_ok} proved non-negative')
    for r in results:
        out.append('')
        out.append(f"  t = {r['exponent']}")
        if r['exponent_normalized'] != r['exponent']:
            out.append(f"      = {r['exponent_normalized']}")
        for o in r['occurrences'][:3]:
            out.append(f'    used in {o}')
        if len(r['occurrences']) > 3:
            out.append(f"    ... and {len(r['occurrences']) - 3} more")
        out.append(f"  status: {r['status']}")
        if 'reason' in r:
            out.append(f"    {r['reason']}")
        if 'method' in r:
            out.append(f"    by {r['method']}")
        if 'core' in r:
            out.append('  because of:')
            for c in r['core']:
                out.append(f"    [{c['label']}] {c['text']}")
        if 'counterexample' in r:
            out.append('  counterexample (satisfies every linear assert over plain variables):')
            out.append('    ' + ', '.join(f'{k}={v}' for k, v in r['counterexample'].items()))
    return '\n'.join(out)


def is_ground(e):
    """True if e mentions no variables (only numerals and operators)."""
    if isinstance(e, str):
        return is_num(e) or e in ('true', 'false')
    return all(is_ground(x) for x in e[1:])


def vacuous_report(proofs):
    """proofs: [(path, results)] -> (file list, report text)"""
    files, out = [], []
    kinds = {'constant-false assert (e.g. (= 2 0))': 0,
             'contradiction between several asserts': 0}
    for f, res in proofs:
        cores = []
        for r in res:
            if r['status'] != 'proved (vacuous)':
                continue
            core = tuple((c['label'], c['text']) for c in r['core'])
            if core not in cores:
                cores.append(core)
        if not cores:
            continue
        files.append(f)
        out.append(f'=== {f}')
        for core in cores:
            k = ('constant-false assert (e.g. (= 2 0))'
                 if len(core) == 1 and is_ground(parse_sexprs(core[0][1])[0])
                 else 'contradiction between several asserts')
            kinds[k] += 1
            out.append(f'  contradictory asserts ({k}):')
            out += [f'    [{lab}] {txt}' for lab, txt in core]
        out.append('')
    hdr = [f'{len(files)} benchmark files where some exponent is "proved" only '
           'because the asserts are contradictory', '']
    hdr += [f'  {v:4d} x {k}' for k, v in kinds.items()] + ['']
    return files, '\n'.join(hdr + out) + '\n'


def iter_files(paths):
    for p in paths:
        if os.path.isdir(p):
            for root, _, files in os.walk(p):
                for f in sorted(files):
                    if f.endswith('.smt2'):
                        yield os.path.join(root, f)
        else:
            yield p


def status_counts(res):
    st = {}
    for r in res:
        st[r['status']] = st.get(r['status'], 0) + 1
    return ', '.join(f'{k}={v}' for k, v in st.items()) or 'no **'


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('paths', nargs='+')
    ap.add_argument('--json', action='store_true', help='JSON output')
    ap.add_argument('--summary', action='store_true', help='one line per file')
    ap.add_argument('--out', metavar='DIR',
                    help='write one proof per benchmark to DIR/<path>.proof.txt '
                         '(and .proof.json with --json) plus DIR/summary.txt, '
                         'DIR/vacuous_files.txt and DIR/vacuous_report.txt')
    args = ap.parse_args()

    all_json = {}
    summary = []
    proofs = []
    for f in iter_files(args.paths):
        try:
            res = explain(Benchmark(f))
        except Exception as ex:  # keep going on directories
            print(f'=== {f}\n  ERROR: {ex!r}', file=sys.stderr)
            summary.append(f'{f}: ERROR {ex!r}')
            continue
        if args.out:
            dst = os.path.join(args.out, os.path.relpath(f).lstrip('./'))
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            with open(dst + '.proof.txt', 'w') as fh:
                fh.write(render_text(f, res) + '\n')
            if args.json:
                with open(dst + '.proof.json', 'w') as fh:
                    json.dump({f: res}, fh, indent=2)
            summary.append(f'{f}: {status_counts(res)}')
            proofs.append((f, res))
        elif args.json:
            all_json[f] = res
        elif args.summary:
            print(f'{f}: {status_counts(res)}')
        else:
            print(render_text(f, res))
            print()
    if args.out:
        totals = {}
        for line in summary:
            for kv in line.split(': ', 1)[1].split(', '):
                if '=' in kv:
                    k, v = kv.rsplit('=', 1)
                    totals[k] = totals.get(k, 0) + int(v)
        with open(os.path.join(args.out, 'summary.txt'), 'w') as fh:
            fh.write(f'{len(summary)} files; exponents: '
                     + ', '.join(f'{k}={v}' for k, v in totals.items()) + '\n\n')
            fh.write('\n'.join(summary) + '\n')
        vfiles, vtext = vacuous_report(proofs)
        with open(os.path.join(args.out, 'vacuous_files.txt'), 'w') as fh:
            fh.write(''.join(f + '\n' for f in vfiles))
        with open(os.path.join(args.out, 'vacuous_report.txt'), 'w') as fh:
            fh.write(vtext)
        print(f'wrote {len(summary)} proofs to {args.out}/ (see {args.out}/summary.txt)')
    elif args.json:
        json.dump(all_json, sys.stdout, indent=2)
        print()


if __name__ == '__main__':
    main()
