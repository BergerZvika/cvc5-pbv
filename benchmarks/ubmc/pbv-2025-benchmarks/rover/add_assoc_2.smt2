; {
;   "name": "add_assoc_2",
;   "preconditions": ["(< r q)", "(< s q)", "(>= u t)"],
;   "lhs": "(bw t ( + (bw u (+ (bw p a) (bw r b))) (bw s c)))",
;   "rhs": "(bw t ( + (bw p a) (bw q (+ (bw r b) (bw s c)))))"
; }
; With r < q, s < q: b+c doesn't overflow at width q, so bw_q(b+c)=b+c.
; With u >= t: bw_t(bw_u(x))=bw_t(x). Both sides reduce to bw_t(a+b+c).
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
(assert (>= u t))
(assert (>= t p))
(assert (>= t r))
(assert (>= t s))
(assert (not (= (pbvadd (pbvadd (pzero_extend (- t p) a) (pzero_extend (- t r) b)) (pzero_extend (- t s) c)) (pbvadd (pzero_extend (- t p) a) (pbvadd (pzero_extend (- t r) b) (pzero_extend (- t s) c))))))
(check-sat)
