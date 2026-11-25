(set-logic PBV)
(declare-fun %A () PBitVec)
(assert (let ((_let_0 (ite (pbvsgt %A (int_to_pbv (pbvsize %A) 0)) (pbvadd (int_to_pbv (pbvsize %A) 0) %A) %A))) (not (= (ite (pbvsgt _let_0 (pbvnot (int_to_pbv (pbvsize %A) 0))) (pbvsub (int_to_pbv (pbvsize %A) 0) _let_0) _let_0) _let_0))))
(check-sat)