; forall (x : BitVec wa), wa <= wt ->
;   ~~~(signExtend wt x) = signExtend wt (~~~x)
; From: not_sext_eq_sext_not_thm: bitwise NOT distributes over sign extension
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (<= wa wt))
(assert (not (= (pbvnot (psign_extend (- wt wa) x)) (psign_extend (- wt wa) (pbvnot x)))))
(check-sat)
