; ∀ (x : BitVec wa) (wb wc wd : Int), wa < wb → wb < wc → wc < wd →
;   zeroExtend wd (zeroExtend wc (zeroExtend wb x)) = zeroExtend wd x
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
(assert (not (= (pzero_extend (- wd wc) (pzero_extend (- wc wb) (pzero_extend (- wb wa) x))) (pzero_extend (- wd wa) x))))
(check-sat)
