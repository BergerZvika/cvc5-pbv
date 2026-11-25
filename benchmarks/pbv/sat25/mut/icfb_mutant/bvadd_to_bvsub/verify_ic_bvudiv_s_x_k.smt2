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
 (pbvnot zero)
)

(define-fun w () PBitVec
 (int_to_pbv (pbvsize s) (pbvsize s))
)

(define-fun addo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend 1 a)) (zext_b (pzero_extend 1 b)))
  (= (pextract (pbvsub zext_a zext_b) (pbvsize s) (pbvsize s)) (int_to_pbv 1 1))
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
  (= (pbvudiv s (pbvudiv s t)) t)
  (and
   (=> (distinct t ones) (pbvugt xhi zero))
   (=>
    (or (distinct t zero) (distinct s zero))
    (and
     (pbvule (pbvudiv s xhi) t)
     (exists ((y PBitVec))
      (and
       (mcb xlo xhi y)
       (=> (= t ones) (and (pbvuge y zero) (pbvule y (pbvudiv s t))))
       (=>
        (distinct t ones)
        (and
         (pbvugt y (pbvudiv s (pbvadd t one)))
         (pbvule y (pbvudiv s t))
        )
       )
      )
     )
    )
   )
  )
 )
)

(define-fun LIT ((x PBitVec)) Bool
 (= (pbvudiv s x) t)
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

