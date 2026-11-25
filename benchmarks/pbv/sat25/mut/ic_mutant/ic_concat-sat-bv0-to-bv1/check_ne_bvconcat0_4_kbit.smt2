(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvnot (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 1)) (int_to_pbv (pbvsize s) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC () Bool
true
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (distinct (pconcat x s) (pconcat tx ts))))
   (=> (exists ((x PBitVec)) (distinct (pconcat x s) (pconcat tx ts))) SC)
  )
 )
)
(check-sat)
