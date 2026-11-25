(set-logic PBV)

(declare-const inv_s PBitVec)

(declare-const t PBitVec)
(declare-const xlo PBitVec)
(declare-const xhi PBitVec)

(define-fun mcb ((xlo PBitVec) (xhi PBitVec) (v PBitVec)) Bool
 (and
  (= (pbvor xhi v) v)
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

(define-fun w () PBitVec
 (int_to_pbv (pbvsize inv_s) (pbvsize inv_s))
)

(define-fun addo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend 1 a)) (zext_b (pzero_extend 1 b)))
  (= (pextract (pbvadd zext_a zext_b) (pbvsize inv_s) (pbvsize inv_s)) (int_to_pbv 1 1))
 )
)

(define-fun mulo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend (pbvsize inv_s) a)) (zext_b (pzero_extend (pbvsize inv_s) b)))
  (distinct
   (pextract (pbvlshr (pbvmul zext_a zext_b) (pzero_extend (pbvsize inv_s) (int_to_pbv (pbvsize inv_s) (pbvsize inv_s)))) (- (pbvsize inv_s) 1) 0)
   zero
  )
 )
)

(define-fun CC ((t PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (and
  (=>
   (= t ones)
   (or
     (mcb xlo xhi zero)
     (mcb xlo xhi one)
   )
  )
  (=>
   (distinct t ones)
   (and
    (not (mulo xlo t))
    (exists ((y PBitVec))
     (and
      (mcb xlo xhi y)
      (pbvugt y zero)
      (not (mulo y t))
     )
    )
   )
  )
 )
)

(define-fun LIT ((x PBitVec) (s PBitVec)) Bool
 (= (pbvudiv s x) t)
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

