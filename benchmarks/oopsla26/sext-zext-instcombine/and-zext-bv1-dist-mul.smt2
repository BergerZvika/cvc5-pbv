; ∀ (c : BitVec 1) (x y : BitVec wt) (wt : Int), 1 < wt →
;   zeroExtend wt c &&& (x * y) = (zeroExtend wt c &&& x) * y
; (c=0: 0&&&(xy)=0; (0&&&x)*y=0*y=0 ✓; c=1: 1&&&(xy)=xy mod 2^wt; (1&&&x)*y=???)
; Actually NOT true in general: for c=1, zext(1)=1, 1 &&& (xy) = xy &&& 1 = xy mod 2 (parity of xy)
; But (1 &&& x) * y = (x &&& 1) * y = parity(x) * y which could differ from parity(xy).
; Example: x=3 (0b11), y=3 (0b11), wt=4: xy=9=1001, xy&&&1=1. (x&&&1)*y=1*3=3≠1. SAT!
; So skip this one.
; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (x &&& allones(wa)) = zeroExtend wt x (trivial identity)
; Better: zext(x) &&& zext(y) = zext(x &&& y)  (already have and-zext-zext-same-width)
; Instead: lowmask-and-sub: (y - zext x) &&& zext y (wrong). Try: zext commutes with not via mask
; zext(bvnot x) &&& zext(bvnot (bvnot x)) = 0 (always)
; = zext(bvnot x) &&& zext(x) = 0 since bvnot x &&& x = 0 in any width
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pzero_extend (- wt wa) (pbvnot x)) (pzero_extend (- wt wa) x)) (int_to_pbv wt 0))))
(check-sat)
