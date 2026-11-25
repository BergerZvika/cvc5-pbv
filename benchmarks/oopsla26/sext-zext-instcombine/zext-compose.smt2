; forall (x : BitVec wa), wa < wb -> wb < wc ->
;   zeroExtend wc (zeroExtend wb x) = zeroExtend wc x
; From: zext_compose_thm: nested zext telescopes to single zext
(set-logic PBV)
(declare-const wa Int)
(declare-const wb Int)
(declare-const wc Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wb))
(assert (< wb wc))
(assert (not (= (pzero_extend (- wc wb) (pzero_extend (- wb wa) x)) (pzero_extend (- wc wa) x))))
(check-sat)
