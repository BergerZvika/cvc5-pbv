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
 (pbvneg zero)
)

(define-fun w () PBitVec
 (int_to_pbv (pbvsize inv_s) 1)
)

(define-fun addo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend 1 a)) (zext_b (pzero_extend 1 b)))
  (= (pextract (pbvadd zext_a zext_b) (pbvsize inv_s) (pbvsize inv_s)) (int_to_pbv 1 1))
 )
)

(define-fun mulo ((a PBitVec) (b PBitVec)) Bool
 (let ((zext_a (pzero_extend (pbvsize inv_s) a)) (zext_b (pzero_extend (pbvsize inv_s) b)))
  (distinct
   (pextract (pbvlshr (pbvmul zext_a zext_b) (pzero_extend (pbvsize inv_s) (int_to_pbv (pbvsize inv_s) 1))) (- (pbvsize inv_s) 1) 0)
   zero
  )
 )
)

(define-fun CC ((t PBitVec) (xlo PBitVec) (xhi PBitVec)) Bool
 (and
  (=> (distinct t ones) (pbvuge xhi t))
  (=> (= t zero) (distinct xlo ones))
  (=>
   (and
    (distinct t zero)
    (distinct t ones)
    (distinct t one)
    (not (mcb xlo xhi t))
   )
   (and
    (not (addo t t))
    (exists ((y PBitVec)(o PBitVec))
     (and
      (mcb xlo xhi (pbvadd (pbvmul y t) o))
      (pbvuge y one)
      (pbvule o (ite (pbvult (pbvsub y one)(pbvsub xhi (pbvmul y t))) (pbvsub y one) (pbvsub xhi (pbvmul y t))))
      (not (mulo y t))
      (not (addo (pbvmul y t) o))
     )
    )
   )
  )
 )
)

(define-fun LIT ((x PBitVec) (s PBitVec)) Bool
 (= (pbvudiv x s) t)
)

; valid xlo/xhi pairs
(assert (= (pbvor (pbvnot xlo) xhi) ones))
(assert (distinct xlo xhi))

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

