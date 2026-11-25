; {
;   "name": "commutativity_add",
;   "preconditions": [],
;   "lhs": "(bw r ( + (bw p a) (bw q b)))",
;   "rhs": "(bw r ( + (bw q b) (bw p a)))"
; }
; Commutativity of addition at width r.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) q))
(assert (>= r p))
(assert (>= r q))
(assert (not (= (pbvadd (pzero_extend (- r p) a) (pzero_extend (- r q) b)) (pbvadd (pzero_extend (- r q) b) (pzero_extend (- r p) a)))))
(check-sat)
