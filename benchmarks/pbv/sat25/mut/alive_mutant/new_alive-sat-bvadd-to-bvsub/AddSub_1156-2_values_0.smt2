(set-logic PBV)
(declare-fun %b () PBitVec)
(assert (let ((_let_0 (psign_extend 1 %b))) (let ((_let_1 (pbvsub %b %b))) (and (= (pbvadd _let_0 _let_0) (psign_extend 1 _let_1)) (not (= _let_1 (pbvshl %b (int_to_pbv (pbvsize %b) 1))))))))
(check-sat)