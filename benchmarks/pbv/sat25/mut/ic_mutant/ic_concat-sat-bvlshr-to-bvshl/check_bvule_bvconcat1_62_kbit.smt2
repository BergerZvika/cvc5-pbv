(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvnot (pbvshl (pbvnot (int_to_pbv (pbvsize tx) 0)) (int_to_pbv (pbvsize tx) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC () Bool
(pbvule s ts)
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (pbvule (pconcat s x) (pconcat ts tx))))
   (=> (exists ((x PBitVec)) (pbvule (pconcat s x) (pconcat ts tx))) SC)
  )
 )
)
(check-sat)
