(set-logic ALL)
(set-option :produce-models true)
(declare-const k Int)
(declare-const _pbv_s Int)
(declare-const _pbv_t Int)

(assert (and (and (and (not (and (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (<= (- (* 2 (mod (div (- (** 2 k) (+ k 1)) (** 2 1)) (** 2 (- k 1)))) (div (- (** 2 k) (+ k 1)) (** 2 1))) (- (* 2 (mod (mod (- (** 2 k) _pbv_x__param_0) (** 2 k)) (** 2 (- k 1)))) (mod (- (** 2 k) _pbv_x__param_0) (** 2 k)))))) true)) (>= k 0)) (< k (** 2 k))) (and (> k 0) (= k k))))
(check-sat)
