; {
;   "name": "one_to_two_mult",
;   "preconditions": ["(> q (+ p 2))", "(> q p)"],
;   "lhs": "(bw p (* (bw 1 1) (bw p x)))",
;   "rhs": "(bw p (- (bw q (* (bw 2 2) (bw p x))) (bw p x)))"
; }
; 1*x = 2*x - x. Ring identity at width p.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) p))
(assert (> q (+ p 2)))
(assert (> q p))
(assert (not (= (pbvmul (int_to_pbv p 1) x) (pbvsub (pbvmul (int_to_pbv p 2) x) x))))
(check-sat)
