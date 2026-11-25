(set-info :smt-lib-version 2.6)
(set-logic PBV)
(declare-fun pbv_width () Int)
(assert (>= pbv_width 1))
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(assert (= (int_to_pbv pbv_width 1) (pbvand (pbvnot (int_to_pbv pbv_width 0)) (pbvand (int_to_pbv pbv_width 1) (int_to_pbv pbv_width 1)))))
(check-sat)
(exit)