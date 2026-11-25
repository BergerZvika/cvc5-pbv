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
(and (pbvsge s ts) (=> (= s ts) (distinct tx (pbvnot (int_to_pbv (pbvsize s) 0)))))
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (pbvsgt (pconcat s x) (pconcat ts tx))))
   (=> (exists ((x PBitVec)) (pbvsgt (pconcat s x) (pconcat ts tx))) SC)
  )
 )
)
(check-sat)
