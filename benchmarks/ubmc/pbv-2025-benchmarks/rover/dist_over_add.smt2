; {
;   "name": "dist_over_add",
;   "preconditions": ["(>= q r)", "(>= u r)", "(>= v r)"],
;   "lhs": "(bw r (* (bw p a) (+ (bw s b) (bw t c))))",
;   "rhs": "(bw r (+ (bw u (* (bw p a) (bw s b))) (bw v (* (bw p a) (bw t c)) ) ))"
; }
; Distributive law: a*(b+c) = a*b + a*c. Holds in ring Z/2^r.
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-const v Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) s))
(declare-const c PBitVec)
(assert (= (pbvsize c) t))
(assert (>= q r))
(assert (>= u r))
(assert (>= v r))
(assert (>= r p))
(assert (>= r s))
(assert (>= r t))
(assert (not (= (pbvmul (pzero_extend (- r p) a) (pbvadd (pzero_extend (- r s) b) (pzero_extend (- r t) c))) (pbvadd (pbvmul (pzero_extend (- r p) a) (pzero_extend (- r s) b)) (pbvmul (pzero_extend (- r p) a) (pzero_extend (- r t) c))))))
(check-sat)
