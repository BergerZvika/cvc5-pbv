(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvlshr (pbvmul s s) s)) (= s (int_to_pbv (pbvsize s) (pbvsize s)))))
(check-sat)
