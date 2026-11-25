; test_sext_thm.extracted_1._1 (generalized)
; ∀ (x : BitVec w) (wt : Int), w < wt →
;   signExtend wt x + signExtend wt (ofBool (x == 0)) ^^^ -1
;   = signExtend wt (ofBool (x != 0)) - signExtend wt x
(set-logic PBV)
(declare-const w Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) w))
(assert (< w wt))
(assert (not (= (pbvxor (pbvadd (psign_extend (- wt w) x) (psign_extend (- wt 1) (ite (= x (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (pbvnot (int_to_pbv wt 0))) (pbvsub (psign_extend (- wt 1) (ite (= x (int_to_pbv w 0)) (int_to_pbv 1 0) (int_to_pbv 1 1))) (psign_extend (- wt w) x)))))
(check-sat)
