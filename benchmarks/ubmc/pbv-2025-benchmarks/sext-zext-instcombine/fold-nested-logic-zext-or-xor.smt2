; ∀ (c1 c2 c3 : BitVec 1) (w : Int), 1 < w →
;   (zeroExtend w c1 ||| zeroExtend w c2) ^^^ zeroExtend w c3
;   = zeroExtend w ((c1 ||| c2) ^^^ c3)
(set-logic PBV)
(declare-const w Int)
(declare-const c1 PBitVec)
(assert (= (pbvsize c1) 1))
(declare-const c2 PBitVec)
(assert (= (pbvsize c2) 1))
(declare-const c3 PBitVec)
(assert (= (pbvsize c3) 1))
(assert (< 1 w))
(assert (not (= (pbvxor (pbvor (pzero_extend (- w 1) c1) (pzero_extend (- w 1) c2)) (pzero_extend (- w 1) c3)) (pzero_extend (- w 1) (pbvxor (pbvor c1 c2) c3)))))
(check-sat)
