; forall (x : BitVec wa), wa < wb -> wb < wc ->
;   signExtend wc (signExtend wb x) = signExtend wc x
; From: sext_compose_thm: nested sext telescopes to single sext
(set-logic PBV)
(declare-const wa Int)
(declare-const wb Int)
(declare-const wc Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wb))
(assert (< wb wc))
(assert (not (= (psign_extend (- wc wb) (psign_extend (- wb wa) x)) (psign_extend (- wc wa) x))))
(check-sat)
