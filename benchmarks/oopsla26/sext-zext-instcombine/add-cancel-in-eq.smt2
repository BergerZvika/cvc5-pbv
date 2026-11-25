; forall (a b c : BitVec wa) ->
;   ofBool (a + b == a + c) = ofBool (b == c)
; From: add_cancel_in_eq_thm: addition is cancellative in equality
(set-logic PBV)
(declare-const wa Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) wa))
(declare-const b PBitVec)
(assert (= (pbvsize b) wa))
(declare-const c PBitVec)
(assert (= (pbvsize c) wa))
(assert (not (= (ite (= (pbvadd a b) (pbvadd a c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (ite (= b c) (int_to_pbv 1 1) (int_to_pbv 1 0)))))
(check-sat)
