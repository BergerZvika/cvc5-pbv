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
  (pbvnot (pbvshl (pbvnot (int_to_pbv (pbvsize s) 0)) (int_to_pbv (pbvsize s) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC ((s PBitVec) (t PBitVec)) Bool
(or (pbvsge (udivtotal (pbvnot (int_to_pbv (pbvsize s) 0)) s) t) (pbvsge (udivtotal max s) t))
)

(assert
 (not
  (and
  (=> (SC s t) (exists ((x PBitVec)) (pbvsge (udivtotal x s) t)))
  (=> (exists ((x PBitVec)) (pbvsge (udivtotal x s) t)) (SC s t))
  )
 )
)
(assert (>= (pbvsize s) 2))
(check-sat)
