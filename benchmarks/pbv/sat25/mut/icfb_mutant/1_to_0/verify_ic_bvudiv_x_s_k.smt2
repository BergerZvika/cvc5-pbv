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
 (int_to_pbv (pbvsize s) 0)
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
  (= (pbvudiv (pbvmul s t) s) t)
  (=>
   (= t zero)
   (pbvult xlo s)
  )
  (=>
   (and (distinct t zero) (distinct s zero))
   (exists ((y PBitVec))
    (let ((overflow (or (mulo s (pbvadd t one)) (addo t one))))
     (and
      (mcb xlo xhi y)
      (=> (not overflow) (pbvult y (pbvmul s (pbvadd t one))))
      (=> overflow (pbvule y ones))
      (pbvuge y (pbvmul s t))
     )
    )
   )
  )
 )
)

(define-fun LIT ((x PBitVec)) Bool
 (= (pbvudiv x s) t)
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

