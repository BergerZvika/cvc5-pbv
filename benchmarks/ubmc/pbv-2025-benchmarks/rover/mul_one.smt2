; {
;   "name": "mul_one",
;   "preconditions": [],
;   "lhs": "(bw p (* (bw p a) (bw q 1)))",
;   "rhs": "(bw p a)"
; }
; a * 1 = a at width p. Trivially true.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(assert (not (= (pbvmul a (int_to_pbv p 1)) a)))
(check-sat)
