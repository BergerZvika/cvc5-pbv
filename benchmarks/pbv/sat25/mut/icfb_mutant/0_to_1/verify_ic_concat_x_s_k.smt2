(set-logic PBV)

(declare-const s PBitVec)
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
 (int_to_pbv (pbvsize s) 1)
)

(define-fun one () PBitVec
 (int_to_pbv (pbvsize s) 1)
)

(define-fun ones () PBitVec
 (pbvnot zero)
)

(define-fun w () PBitVec
 (int_to_pbv (pbvsize s) (pbvsize s))
)

(define-fun IC ((s PBitVec) (tx PBitVec) (ts PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (and
  (= s ts)
  (mcb xlo xhi tx)
 )
)

(define-fun LIT ((x PBitVec)) Bool
 (= (pconcat x s) (pconcat tx ts))
)

; valid xlo/xhi pairs
(assert (= (pbvor (pbvnot xlo) xhi) ones))

(assert
 (distinct
  (IC s tx ts xlo xhi)
  (exists ((x PBitVec))
   (and
    (mcb xlo xhi x)
    (LIT x)
   )
  )
 )
)

(check-sat)
(exit)

