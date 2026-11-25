(set-logic ALL)
(set-option :produce-models true)
(declare-const k Int)
(declare-const _pbv_s Int)
(declare-const _pbv_t Int)

(assert (and (and (and (and (and (not (and (=> (or (< (- (* 2 (mod _pbv_s (** 2 (- k 1)))) _pbv_s) (- (* 2 (mod (div _pbv_s (** 2 (- (** 2 k) (+ _pbv_t 1)))) (** 2 (- k 1)))) (div _pbv_s (** 2 (- (** 2 k) (+ _pbv_t 1)))))) (< _pbv_t _pbv_s)) (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (< _pbv_t (ite (= (mod (div _pbv_s (** 2 (- k 1))) (** 2 (- (+ (- k 1) 1) (- k 1)))) 0) (div _pbv_s (** 2 _pbv_x__param_0)) (- (** 2 k) (+ (div (- (** 2 k) (+ _pbv_s 1)) (** 2 _pbv_x__param_0)) 1))))))) (=> (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (< _pbv_t (ite (= (mod (div _pbv_s (** 2 (- k 1))) (** 2 (- (+ (- k 1) 1) (- k 1)))) 0) (div _pbv_s (** 2 _pbv_x__param_0)) (- (** 2 k) (+ (div (- (** 2 k) (+ _pbv_s 1)) (** 2 _pbv_x__param_0)) 1)))))) (or (< (- (* 2 (mod _pbv_s (** 2 (- k 1)))) _pbv_s) (- (* 2 (mod (div _pbv_s (** 2 (- (** 2 k) (+ _pbv_t 1)))) (** 2 (- k 1)))) (div _pbv_s (** 2 (- (** 2 k) (+ _pbv_t 1)))))) (< _pbv_t _pbv_s))))) (>= _pbv_s 0)) (< _pbv_s (** 2 k))) (>= _pbv_t 0)) (< _pbv_t (** 2 k))) (and (and (and (> k 0) (= k k)) (= 1 1)) (> 1 0))))
(check-sat)
