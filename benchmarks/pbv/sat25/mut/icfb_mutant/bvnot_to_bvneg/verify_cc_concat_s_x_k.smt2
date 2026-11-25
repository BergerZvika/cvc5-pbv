(set-logic PBV)

(declare-const tx PBitVec)
(declare-const ts PBitVec)
(declare-const xlo PBitVec)
(declare-const xhi PBitVec)

(define-fun mcb ((xlo PBitVec) (xhi PBitVec) (v PBitVec)) Bool
 (and
  (= (pbvand xhi v) v)
  (= (pbvor xlo v) v)
 )
)

(define-fun odd ((v PBitVec)) Bool
 (= (pextract v 0 0) (int_to_pbv 1 1))
)

(define-fun zero () PBitVec
 (int_to_pbv (pbvsize tx) 0)
)

(define-fun one () PBitVec
 (int_to_pbv (pbvsize tx) 1)
)

(define-fun ones () PBitVec
 (pbvneg zero)
)

(define-fun w () PBitVec
 (int_to_pbv (pbvsize tx) (pbvsize tx))
)

(define-fun CC ((tx PBitVec) (ts PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (mcb xlo xhi tx)
)

(define-fun LIT ((x PBitVec) (s PBitVec)) Bool
 (= (pconcat s x) (pconcat ts tx))
)

; valid xlo/xhi pairs
(assert (= (pbvor (pbvnot xlo) xhi) ones))

(assert
 (distinct
  (CC tx ts xlo xhi)
  (exists ((x PBitVec) (s PBitVec))
   (and
    (mcb xlo xhi x)
    (LIT x s)
   )
  )
 )
)

(check-sat)
(exit)

