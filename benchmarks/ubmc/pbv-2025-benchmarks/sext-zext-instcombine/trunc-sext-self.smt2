; forall (x : BitVec wa), wa <= wt ->
;   truncate wa (signExtend wt x) = x
; From: trunc_sext_self_thm: truncating a sign-extended value recovers the original
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (<= wa wt))
(assert (not (= (pextract (psign_extend (- wt wa) x) (- wa 1) 0) x)))
(check-sat)
