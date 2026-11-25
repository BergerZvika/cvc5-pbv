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

(define-fun addo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend 1 a)) (zext_b (pzero_extend 1 b)))
  (= (pextract (pbvadd zext_a zext_b) (pbvsize s) (pbvsize s)) (int_to_pbv 1 1))
 )
)

(define-fun mulo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend (pbvsize s) a)) (zext_b (pzero_extend (pbvsize s) b)))
  (distinct
   (pextract (pbvlshr (pbvmul zext_a zext_b) (pzero_extend (pbvsize s) (int_to_pbv (pbvsize s) (pbvsize s)))) (- (pbvsize s) 1) 0)
   zero
  )
 )
)

(define-fun IC ((s PBitVec) (t PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (and
  (pbvuge (pbvnot (pbvneg s)) t)
  (=>
   (or (= s zero) (= t ones))
   (mcb xlo xhi t)
  )
  (=>
   (and
    (distinct s zero)
    (distinct t ones)
   )
   (exists ((y PBitVec))
    (and
     (mcb xlo xhi (pbvadd (pbvmul s y) t))
     (not (mulo s y))
     (not (addo (pbvmul s y) t))
    )
   )
  )
 )
)

(define-fun LIT ((x PBitVec)) Bool
 (= (pbvurem x s) t)
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

