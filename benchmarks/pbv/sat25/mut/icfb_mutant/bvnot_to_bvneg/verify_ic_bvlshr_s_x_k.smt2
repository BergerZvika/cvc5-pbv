(set-logic PBV)

(declare-const s PBitVec)

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
 (int_to_pbv (pbvsize s) 0)
)

(define-fun one () PBitVec
 (int_to_pbv (pbvsize s) 1)
)

(define-fun ones () PBitVec
 (pbvneg zero)
)

(define-fun mins () PBitVec
 (pbvnot (pbvlshr ones one))
)

(define-fun maxs () PBitVec
 (pbvnot mins)
)

(define-fun w () PBitVec
 (int_to_pbv (pbvsize s) (pbvsize s))
)

(define-fun msb ((v PBitVec)) PBitVec
 (pextract v (- (pbvsize s) 1) (- (pbvsize s) 1))
)

(define-fun IC ((s PBitVec) (t PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (let ((y (pbvsub (clz t) (clz s)))) (and (pbvule (clz s) (clz t)) (=> (distinct t zero) (= (pbvlshr s y) t)) (=> (= t zero) (or (pbvuge xhi y) (= s zero))) (=> (distinct t zero) (mcb xlo xhi y))))
)

(define-fun LIT ((x PBitVec)) Bool
 (= (pbvlshr s x) t)
)

; valid xlo/xhi pairs
(assert (= (pbvor (pbvnot xlo) xhi) ones))

(assert
 (distinct
  (IC s t xlo xhi)
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

