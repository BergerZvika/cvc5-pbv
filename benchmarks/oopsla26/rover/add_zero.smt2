; {
;   "name": "add_zero",
;   "preconditions": [],
;   "lhs": "(bw p (+ (bw p a) (bw q 0)))",
;   "rhs": "(bw p a)"
; }
; a + 0 = a at width p. Trivially true.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(assert (not (= (pbvadd a (int_to_pbv p 0)) a)))
(check-sat)
