; {
;   "name": "add_assoc_4",
;   "preconditions": ["(< r q)", "(< s q)", "(< p u)", "(< r u)"],
;   "lhs": "(bw t ( + (bw u (+ (bw p a) (bw r b))) (bw s c)))",
;   "rhs": "(bw t ( + (bw p a) (bw q (+ (bw r b) (bw s c)))))"
; }
; With p < u, r < u: a+b doesn't overflow at width u.
; With r < q, s < q: b+c doesn't overflow at width q.
; Both sides reduce to bw_t(a+b+c).
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
(assert (< r q))
(assert (< s q))
(assert (< p u))
(assert (< r u))
(assert (>= t p))
(assert (>= t r))
(assert (>= t s))
(assert (not (= (pbvadd (pbvadd (pzero_extend (- t p) a) (pzero_extend (- t r) b)) (pzero_extend (- t s) c)) (pbvadd (pzero_extend (- t p) a) (pbvadd (pzero_extend (- t r) b) (pzero_extend (- t s) c))))))
(check-sat)
