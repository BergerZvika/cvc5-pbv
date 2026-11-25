; {
;   "name": "sum_same",
;   "preconditions": [],
;   "lhs": "(bw q (+ (bw p a) (bw p a)))",
;   "rhs": "(bw q (* (bw 2 2) (bw p a)))"
; }
; a + a = 2 * a. Ring identity at width q.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(assert (>= q p))
(assert (not (= (pbvadd (pzero_extend (- q p) a) (pzero_extend (- q p) a)) (pbvmul (int_to_pbv q 2) (pzero_extend (- q p) a)))))
(check-sat)
