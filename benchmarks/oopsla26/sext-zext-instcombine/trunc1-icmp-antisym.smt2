; forall (a b : BitVec wa) (wt : Int), 1 <= wt ->
;   trunc 1 (zeroExtend wt (a <s b) &&& zeroExtend wt (b <s a)) = 0
; From: trunc1_icmp_antisym_thm: a<b and b<a cannot both be true (antisymmetry)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) wa))
(declare-const b PBitVec)
(assert (= (pbvsize b) wa))
(assert (<= 1 wt))
(assert (not (= (pextract (pbvand (pzero_extend (- wt 1) (ite (pbvslt a b) (int_to_pbv 1 1) (int_to_pbv 1 0))) (pzero_extend (- wt 1) (ite (pbvslt b a) (int_to_pbv 1 1) (int_to_pbv 1 0)))) 0 0) (int_to_pbv 1 0))))
(check-sat)
