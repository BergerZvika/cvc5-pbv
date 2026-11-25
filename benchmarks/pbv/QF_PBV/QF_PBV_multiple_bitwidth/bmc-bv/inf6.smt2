(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :category "industrial")
(set-info :source |
  Generated using using the Low-Level Bounded Model Checker LLBMC.
  C files used in the paper: Florian Merz, Stephan Falke, Carsten Sinz: LLBMC: Bounded Model Checking of C and C++ Programs Using a Compiler IR. VSTTE 2012: 146-161
|)
(declare-fun a_0x15ff960 () PBitVec)
(declare-fun b_0x15ffa10 () PBitVec)
(assert (= (pbvsize a_0x15ff960) (pbvsize b_0x15ffa10)))
(assert (let ((?x1 (int_to_pbv 1 0))) (let ((?x2 (int_to_pbv 1 1))) (let ((?x3 (int_to_pbv (pbvsize a_0x15ff960) 0))) (let ((?x4 a_0x15ff960)) (let ((?x5 b_0x15ffa10)) (let (($x6 (pbvsgt ?x4 ?x3))) (let (($x7 (pbvsle ?x4 ?x3))) (let (($x8 (pbvsle ?x5 ?x3))) (let (($x9 (and $x6 $x8))) (let (($x10 (pbvsgt ?x5 ?x3))) (let (($x11 (and $x7 $x10))) (let (($x12 (or $x9 $x11))) (let (($x13 (and $x12 $x7))) (let (($x14 (and $x12 $x8))) (let ((?x15 (ite $x13 ?x2 ?x1))) (let ((?x16 (ite $x13 ?x1 ?x2))) (let ((?x17 (ite $x14 ?x15 ?x16))) (let (($x18 (= ?x17 (int_to_pbv (pbvsize ?x17) 1)))) (let (($x19 (and $x12 $x18))) (let (($x20 (not $x12))) (let (($x21 (not $x19))) (let (($x22 (or $x21 $x20))) (let (($x23 (not $x22))) $x23))))))))))))))))))))))))
(check-sat)
(exit)
