; forall (x : BitVec wa), wa <= wt ->
;   truncate wa (zeroExtend wt x) = x
; From: trunc_zext_self_thm: truncating a zero-extended value recovers the original
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (<= wa wt))
(assert (not (= (pextract (pzero_extend (- wt wa) x) (- wa 1) 0) x)))
(check-sat)
