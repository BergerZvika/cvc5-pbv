(set-logic ALL)
(set-option :produce-models true)
(declare-const k Int)
(declare-const _pbv_s Int)
(declare-const _pbv_t Int)

(assert (and (and (and (not (and (=> (distinct _pbv_t (- (** 2 k) (+ (div (- (** 2 k) (+ 0 1)) (** 2 1)) 1))) (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (< (- (* 2 (mod (- (** 2 k) (+ _pbv_x__param_0 1)) (** 2 (- k 1)))) (- (** 2 k) (+ _pbv_x__param_0 1))) (- (* 2 (mod _pbv_t (** 2 (- k 1)))) _pbv_t))))) (=> (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (< (- (* 2 (mod (- (** 2 k) (+ _pbv_x__param_0 1)) (** 2 (- k 1)))) (- (** 2 k) (+ _pbv_x__param_0 1))) (- (* 2 (mod _pbv_t (** 2 (- k 1)))) _pbv_t)))) (distinct _pbv_t (- (** 2 k) (+ (div (- (** 2 k) (+ 0 1)) (** 2 1)) 1)))))) (>= _pbv_t 0)) (< _pbv_t (** 2 k))) (and (> k 0) (= k k))))
(check-sat)
