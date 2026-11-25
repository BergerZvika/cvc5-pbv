(set-logic PBV)
(declare-fun %A () PBitVec)
(assert (let ((_let_0 (ite (pbvsgt %A (int_to_pbv (pbvsize %A) 0)) %A (pbvsub (int_to_pbv (pbvsize %A) 0) %A)))) (not (= (ite (pbvsgt _let_0 (pbvneg (int_to_pbv (pbvsize %A) 0))) _let_0 (pbvsub (int_to_pbv (pbvsize %A) 0) _let_0)) _let_0))))
(check-sat)