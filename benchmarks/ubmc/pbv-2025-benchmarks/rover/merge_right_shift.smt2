; {
;   "name": "merge_right_shift",
;   "preconditions": ["(>= u p)", "(> t s)", "(> t q)"],
;   "lhs": "(bw r (>> (bw u (>> (bw p a) (bw q b))) (bw s c)))",
;   "rhs": "(bw r (>> (bw p a) (bw t (+ (bw q b) (bw s c)))))"
; }
; (a >> b) >> c = a >> (b + c), when b + c doesn't overflow at width t.
; t > q, t > s guarantee no overflow. Computed at width w = max(p, t).
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-const w Int)
(assert (or (= w p) (= w t)))
(assert (>= w p))
(assert (>= w t))
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) q))
(declare-const c PBitVec)
(assert (= (pbvsize c) s))
(assert (>= u p))
(assert (> t s))
(assert (> t q))
(assert (not (= (pbvlshr (pbvlshr (pzero_extend (- w p) a) (pzero_extend (- w q) b)) (pzero_extend (- w s) c)) (pbvlshr (pzero_extend (- w p) a) (pzero_extend (- w t) (pbvadd (pzero_extend (- t q) b) (pzero_extend (- t s) c)))))))
(check-sat)
