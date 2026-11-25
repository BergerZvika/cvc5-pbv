(set-logic ALL)
(set-option :produce-models true)
(declare-const k Int)
(declare-const _pbv_s Int)
(declare-const _pbv_t Int)

(assert (and (and (and (and (and (not (and (=> (or (distinct _pbv_s 0) (distinct _pbv_t 0)) (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (distinct (ite (= _pbv_x__param_0 0) _pbv_s (ite (= _pbv_x__param_0 0) _pbv_s (mod _pbv_s _pbv_x__param_0))) _pbv_t)))) (=> (exists ((_pbv_x__param_0 Int)) (and (and (>= _pbv_x__param_0 0) (< _pbv_x__param_0 (** 2 k))) (distinct (ite (= _pbv_x__param_0 0) _pbv_s (ite (= _pbv_x__param_0 0) _pbv_s (mod _pbv_s _pbv_x__param_0))) _pbv_t))) (or (distinct _pbv_s 0) (distinct _pbv_t 0))))) (>= _pbv_t 0)) (< _pbv_t (** 2 k))) (>= _pbv_s 0)) (< _pbv_s (** 2 k))) (and (> k 0) (= k k))))
(check-sat)
