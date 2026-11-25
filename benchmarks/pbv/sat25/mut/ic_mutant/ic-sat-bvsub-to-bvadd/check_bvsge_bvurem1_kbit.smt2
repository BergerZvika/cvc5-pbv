(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun t () PBitVec)

(define-fun udivtotal ((a PBitVec) (b PBitVec)) PBitVec
  (ite (= b (int_to_pbv (pbvsize s) 0)) (pbvnot (int_to_pbv (pbvsize s) 0)) (pbvudiv a b))
)
(define-fun uremtotal ((a PBitVec) (b PBitVec)) PBitVec
  (ite (= b (int_to_pbv (pbvsize s) 0)) a (pbvurem a b))
)
(define-fun min () PBitVec
  (pbvnot (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 0)) (int_to_pbv (pbvsize s) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC ((s PBitVec) (t PBitVec)) Bool
(and (=> (pbvsge s (int_to_pbv (pbvsize s) 0)) (pbvsge s t)) (=> (and (pbvslt s (int_to_pbv (pbvsize s) 0)) (pbvsge t (int_to_pbv (pbvsize s) 0))) (pbvugt (pbvadd s t) t)))
)

(assert
 (not
  (and
  (=> (SC s t) (exists ((x PBitVec)) (pbvsge (uremtotal s x) t)))
  (=> (exists ((x PBitVec)) (pbvsge (uremtotal s x) t)) (SC s t))
  )
 )
)
(check-sat)
