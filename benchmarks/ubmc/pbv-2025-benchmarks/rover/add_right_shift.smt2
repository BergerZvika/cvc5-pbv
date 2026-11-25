; {
;   "name": "add_right_shift",
;   "preconditions": [
;     "(>= q t)",
;     "(>= s (+ p (- (^ 2 u) 1)))",
;     "(> v s)",
;     "(> v t)"
;   ],
;   "lhs": "(bw r (+ (bw p a) (bw q (>> (bw t b) (bw u c)))))",
;   "rhs": "(bw r (>> (bw v (+ (bw s (<< (bw p a) (bw u c))) (bw t b))) (bw u c)))"
; }
; Identity: a + (b >> c) = ((a << c) + b) >> c, when a << c doesn't overflow.
; We compute at width v (large enough) and use value constraints for no-overflow.
; The width constraint s >= p + 2^u - 1 can't be expressed in linear arithmetic,
; so we encode it as value constraints: shift and addition don't overflow.
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
(assert (= (pbvsize b) t))
(declare-const c PBitVec)
(assert (= (pbvsize c) u))
(assert (>= q t))
(assert (> v s))
(assert (> v t))
(assert (> v p))
(assert (>= v u))
(assert (= (pbvlshr (pbvshl (pzero_extend (- v p) a) (pzero_extend (- v u) c)) (pzero_extend (- v u) c)) (pzero_extend (- v p) a)))
(assert (pbvuge (pbvnot (pbvshl (pzero_extend (- v p) a) (pzero_extend (- v u) c))) (pzero_extend (- v t) b)))
(assert (not (= (pbvadd (pzero_extend (- v p) a) (pbvlshr (pzero_extend (- v t) b) (pzero_extend (- v u) c))) (pbvlshr (pbvadd (pbvshl (pzero_extend (- v p) a) (pzero_extend (- v u) c)) (pzero_extend (- v t) b)) (pzero_extend (- v u) c)))))
(check-sat)
