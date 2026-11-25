; define i32 @trunc_sel_equal_sext(i32 %a, i1 %cmp) {
; ; CHECK-LABEL: @trunc_sel_equal_sext(
; ; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[A:%.*]], 16
; ; CHECK-NEXT:    [[TMP2:%.*]] = ashr exact i32 [[TMP1]], 16
; ; CHECK-NEXT:    [[EXT:%.*]] = select i1 [[CMP:%.*]], i32 [[TMP2]], i32 42
; ; CHECK-NEXT:    ret i32 [[EXT]]
; ;
;   %trunc = trunc i32 %a to i16
;   %sel = select i1 %cmp, i16 %trunc, i16 42
;   %ext = sext i16 %sel to i32
;   ret i32 %ext
; }
(set-logic PBV)
(declare-const w1 Int)
(declare-const w2 Int)
(declare-const cmp PBitVec)
(assert (= (pbvsize cmp) 1))
(declare-const a PBitVec)
(assert (= (pbvsize a) w2))
(declare-const b PBitVec)
(assert (= (pbvsize b) w1))
(assert (< w1 w2))
(assert (distinct (psign_extend (- w2 w1) (ite (= cmp (int_to_pbv 1 1)) (pextract a (- w1 1) 0) b)) (ite (= cmp (int_to_pbv 1 1)) (pbvashr (pbvshl a (int_to_pbv w2 (- w2 w1))) (int_to_pbv w2 (- w2 w1))) (psign_extend (- w2 w1) b))))
(check-sat)
