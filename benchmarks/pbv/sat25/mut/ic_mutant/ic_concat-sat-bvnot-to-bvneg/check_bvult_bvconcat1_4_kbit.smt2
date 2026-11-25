(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvneg (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 0)) (int_to_pbv (pbvsize s) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC () Bool
(and (pbvule s ts) (=> (= s ts) (distinct tx (int_to_pbv (pbvsize s) 0))))
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (pbvult (pconcat s x) (pconcat ts tx))))
   (=> (exists ((x PBitVec)) (pbvult (pconcat s x) (pconcat ts tx))) SC)
  )
 )
)
(check-sat)
