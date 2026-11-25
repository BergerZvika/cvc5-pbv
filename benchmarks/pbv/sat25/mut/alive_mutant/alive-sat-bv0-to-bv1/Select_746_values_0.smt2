(set-logic PBV)
(declare-fun %A () PBitVec)
(assert (let ((_let_0 (pbvsub (int_to_pbv (pbvsize %A) 1) %A))) (let ((_let_1 (ite (pbvslt %A (int_to_pbv (pbvsize %A) 0)) %A _let_0))) (not (= (ite (pbvsgt _let_1 (int_to_pbv (pbvsize %A) 0)) _let_1 (pbvsub (int_to_pbv (pbvsize %A) 0) _let_1)) (ite (pbvsgt %A (int_to_pbv (pbvsize %A) 0)) %A _let_0))))))
(check-sat)