; {
;   "name": "sub_to_neg",
;   "preconditions": [],
;   "lhs": "(bw r (- (bw p a) (bw q b)))",
;   "rhs": "(bw r (+ (bw p a) (- (bw q b))))"
; }
(set-logic PBV)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const pq1 Int)
(assert (or (= pq1 (+ p 1)) (= pq1 (+ q 1))))
(assert (>= pq1 (+ p 1)))
(assert (>= pq1 (+ q 1)))
(declare-const a PBitVec)
(assert (= (pbvsize a) p))
(declare-const b PBitVec)
(assert (= (pbvsize b) q))
(assert (not (= (pzero_extend r (pbvsub (pzero_extend (- pq1 p) a) (pzero_extend (- pq1 q) b))) (pzero_extend r (pbvadd (pzero_extend (- pq1 p) a) (pbvneg (pzero_extend (- pq1 q) b)))))))
(check-sat)
