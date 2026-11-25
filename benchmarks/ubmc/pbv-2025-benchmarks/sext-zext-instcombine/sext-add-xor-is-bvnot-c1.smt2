; ∀ (x : BitVec wt) (wt : Int), 1 < wt →
;   (signExtend wt 1#1 + x) ^^^ signExtend wt 1#1 = bvnot x
; (sext(1)=-1; -1+x=x-1; (x-1) ^^^ (-1) = ~(x-1) = -x+1-1 = bvnot x. Actually ~y = -1-y, so ~(x-1) = -1-(x-1) = -x = bvnot(x)? No.
; bvnot x = allones ^^^ x = -1-x. And (x-1) ^^^ (-1) = -1-(x-1) = -x = 0-x. Hmm.
; Let me just check: it should be bvsub 0 x or bvnot x... let me use 0-x)
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< 1 wt))
(assert (not (= (pbvxor (pbvadd (psign_extend (- wt 1) (int_to_pbv 1 1)) x) (psign_extend (- wt 1) (int_to_pbv 1 1))) (pbvsub (int_to_pbv wt 0) x))))
(check-sat)
