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

;(define-fun SC ((s PBitVec) (t PBitVec)) Bool
;(or  (pbvuge (pbvlshr s (int_to_pbv (pbvsize s) 0)) t) (pbvuge (pbvshl s (int_to_pbv (pbvsize s) 1)) t) (pbvuge (pbvshl s (int_to_pbv (pbvsize s) 2)) t) (pbvuge (pbvshl s (int_to_pbv (pbvsize s) 3)) t) (pbvuge (pbvshl s (int_to_pbv (pbvsize s) (pbvsize s))) t))
;)

(define-fun SC ((s PBitVec) (t PBitVec)) Bool (exists ((i PBitVec)) (and (pbvuge i  (int_to_pbv (pbvsize s) 0)) (pbvule i (int_to_pbv (pbvsize s) (pbvsize s))) (pbvuge (pbvshl s i) t))))

(assert
 (not
  (and
  (=> (SC s t) (exists ((x PBitVec)) (pbvuge (pbvshl s x) t)))
  (=> (exists ((x PBitVec)) (pbvuge (pbvshl s x) t)) (SC s t))
  )
 )
)
(check-sat)
