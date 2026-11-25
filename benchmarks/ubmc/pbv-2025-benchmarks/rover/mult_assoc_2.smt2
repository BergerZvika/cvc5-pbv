; {
;   "name": "mult_assoc_2",
;   "preconditions": ["(>= q t)", "(<= (+ p r) u)"],
;   "lhs": "(bw t ( * (bw u (* (bw p a) (bw r b))) (bw s c)))",
;   "rhs": "(bw t ( * (bw p a) (bw q (* (bw r b) (bw s c)))))"
; }
; Associativity of multiplication at width t. Holds in ring Z/2^t.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) r))
(declare-const c PBitVec)
(assert (= (pbvsize c) s))
(assert (>= q t))
(assert (<= (+ p r) u))
(assert (>= t p))
(assert (>= t r))
(assert (>= t s))
(assert (not (= (pbvmul (pbvmul (pzero_extend (- t p) a) (pzero_extend (- t r) b)) (pzero_extend (- t s) c)) (pbvmul (pzero_extend (- t p) a) (pbvmul (pzero_extend (- t r) b) (pzero_extend (- t s) c))))))
(check-sat)
