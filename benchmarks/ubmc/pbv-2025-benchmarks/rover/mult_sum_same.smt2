; {
;   "name": "mult_sum_same",
;   "preconditions": ["(> t p)", "(> t 1)", "(>= s (+ p q))"],
;   "lhs": "(bw r (+ (bw s (* (bw p a) (bw q b))) (bw q b)))",
;   "rhs": "(bw r (* (bw t (+ (bw p a) (bw 1 1))) (bw q b)))"
; }
; a*b + b = (a+1)*b. Ring identity at width r.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) q))
(assert (> t p))
(assert (> t 1))
(assert (>= s (+ p q)))
(assert (>= r p))
(assert (>= r q))
(assert (not (= (pbvadd (pbvmul (pzero_extend (- r p) a) (pzero_extend (- r q) b)) (pzero_extend (- r q) b)) (pbvmul (pbvadd (pzero_extend (- r p) a) (int_to_pbv r 1)) (pzero_extend (- r q) b)))))
(check-sat)
