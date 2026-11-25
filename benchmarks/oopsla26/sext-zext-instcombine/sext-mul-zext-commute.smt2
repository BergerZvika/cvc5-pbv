; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   signExtend wt x * zeroExtend wt y = zeroExtend wt x * signExtend wt y
; (multiplication is commutative, and sext/zext just pad same bits for x,y)
; Actually: this only holds trivially because bvmul is commutative and we flip x and y.
; No wait: LHS=sext(x)*zext(y), RHS=zext(x)*sext(y). Different values in general.
; x=1(all ones="-1" as signed), y=1: sext(1)=-1, zext(1)=1. LHS=-1*1=-1. RHS=1*(-1)=-1. Equal by commutativity of *!
; x=2,y=1(if wa>=3): sext(2)=-2 (if wa=3, 010 is 2, sext=-2... wait 010 sign extended is 00010 = 2). zext(2)=2. LHS=-2*1=-2. RHS=2*(-... wait zext(x)=2, sext(y)=sext(1)=sext(0b001)=1. RHS=2*1=2. -2≠2. FALSE.
; Skip this one.
(set-logic PBV)
