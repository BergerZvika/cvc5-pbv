(set-logic PBV)

(declare-const inv_s PBitVec)
(declare-const t PBitVec)
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
 (int_to_pbv (pbvsize inv_s) 0)
)

(define-fun one () PBitVec
 (int_to_pbv (pbvsize inv_s) 1)
)

(define-fun ones () PBitVec
 (pbvnot zero)
)

(define-fun mins () PBitVec
 (pbvnot (pbvshl ones one))
)

(define-fun maxs () PBitVec
 (pbvnot mins)
)

(define-fun w () PBitVec
 (int_to_pbv (pbvsize inv_s) (pbvsize inv_s))
)

(define-fun msb ((v PBitVec)) PBitVec
 (pextract v (- (pbvsize inv_s) 1) (- (pbvsize inv_s) 1))
)

(define-fun CC ((t PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (= (pbvand (pbvlshr ones xlo) t) t)
)

(define-fun LIT ((x PBitVec) (s PBitVec)) Bool
 (= (pbvlshr s x) t)
)

; valid xlo/xhi pairs
(assert (= (pbvor (pbvnot xlo) xhi) ones))

(assert
 (distinct
  (CC t xlo xhi)
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

