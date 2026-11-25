; ∀ (x : BitVec wa) (wb wc wd : Int), wa < wb → wb < wc → wc < wd →
;   signExtend wd (signExtend wc (signExtend wb x)) = signExtend wd x
(set-logic PBV)
(declare-const wa Int)
(declare-const wb Int)
(declare-const wc Int)
(declare-const wd Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wb))
(assert (< wb wc))
(assert (< wc wd))
(assert (not (= (psign_extend (- wd wc) (psign_extend (- wc wb) (psign_extend (- wb wa) x))) (psign_extend (- wd wa) x))))
(check-sat)
