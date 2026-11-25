(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvshl s (pbvurem s (int_to_pbv (pbvsize s) (pbvsize s))))) (pbvult s (pbvshl s s))))
(check-sat)
