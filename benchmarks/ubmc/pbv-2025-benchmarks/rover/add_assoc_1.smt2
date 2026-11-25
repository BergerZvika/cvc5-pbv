; {
;   "name": "add_assoc_1",
;   "preconditions": ["(>= q t)", "(>= u t)"],
;   "lhs": "(bw t ( + (bw u (+ (bw p a) (bw r b))) (bw s c)))",
;   "rhs": "(bw t ( + (bw p a) (bw q (+ (bw r b) (bw s c)))))"
; }
; Since u >= t and q >= t, both sides reduce to (a + b + c) mod 2^t.
; We encode at width t directly, requiring t >= p, r, s for zero-extension.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) r))
(declare-const c PBitVec)
(assert (= (pbvsize c) s))
(assert (>= q t))
(assert (>= u t))
(assert (>= t p))
(assert (>= t r))
(assert (>= t s))
(assert (not (= (pbvadd (pbvadd (pzero_extend (- t p) a) (pzero_extend (- t r) b)) (pzero_extend (- t s) c)) (pbvadd (pzero_extend (- t p) a) (pbvadd (pzero_extend (- t r) b) (pzero_extend (- t s) c))))))
(check-sat)
