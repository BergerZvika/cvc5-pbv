(set-logic PBV)
(set-option :produce-models true)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvnot (pbvlshr (pbvnot (int_to_pbv (pbvsize tx) 0)) (int_to_pbv (pbvsize tx) 1)))
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
   (=> SC (exists ((x PBitVec)) (distinct (pconcat s x) (pconcat ts tx))))
   (=> (exists ((x PBitVec)) (distinct (pconcat s x) (pconcat ts tx))) SC)
  )
 )
)
(check-sat)
