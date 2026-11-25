; {
;   "name": "commutativity_mult",
;   "preconditions": [],
;   "lhs": "(bw r ( * (bw p a) (bw q b)))",
;   "rhs": "(bw r ( * (bw q b) (bw p a)))"
; }
; Commutativity of multiplication at width r.
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
(assert (not (= (pbvmul (pzero_extend (- r p) a) (pzero_extend (- r q) b)) (pbvmul (pzero_extend (- r q) b) (pzero_extend (- r p) a)))))
(check-sat)
