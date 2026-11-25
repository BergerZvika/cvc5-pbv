; define i32 @trunc_sel_equal_zext(i32 %a, i1 %cmp) {
; ; CHECK-LABEL: @trunc_sel_equal_zext(
; ; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 65535
; ; CHECK-NEXT:    [[EXT:%.*]] = select i1 [[CMP:%.*]], i32 [[TMP1]], i32 42
; ; CHECK-NEXT:    ret i32 [[EXT]]
; ;
;   %trunc = trunc i32 %a to i16
;   %sel = select i1 %cmp, i16 %trunc, i16 42
;   %ext = zext i16 %sel to i32
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
(assert (distinct (pzero_extend (- w2 w1) (ite (= cmp (int_to_pbv 1 1)) (pextract a (- w1 1) 0) b)) (ite (= cmp (int_to_pbv 1 1)) (pbvand a (pzero_extend (- w2 w1) (int_to_pbv w1 -1))) (pzero_extend (- w2 w1) b))))
(check-sat)
