#!/bin/bash
# Re-run every evaluation table of the paper (exp-pbv-paper/tables/eval_*.tex,
# and Table 14 tab:pre-reduce of the appendix in main.tex).
#
# usage:  bash scripts/run_experiments_paper-tables.sh [OPTION...] SELECTION...
#   SELECTION = TABLE              every configuration of TABLE
#             | TABLE:CFG[,CFG...] only the given configurations of TABLE
#             | all                every configuration of every table
#   TABLE     = pbv | cav26 | exp | oopsla | exp-reducer
#   --list            print the configurations of each table and exit
#   --dry-run         print the commands instead of running them
#   --backend local   run on this machine with scripts/run_local.py (default)
#   --backend slurm   submit Slurm array jobs with scripts/submit-job.sh
#   --jobs N          local backend: parallel runs (default: min(#cpus, RAM/8GB))
#   --time-limit=SEC  CPU-time limit per benchmark in seconds (default: 60;
#                     configurations with their own limit keep it)
#   --smoke-test      instead of a SELECTION: a partial Table 11 (eval_pbv) in ~5 minutes --
#                     the 7 solver columns on 48 benchmarks (2-5 per set), with a 5 s limit
#                     (--time-limit overrides) and 2 GB per run; unpacks its benchmarks
#                     itself, prints the table and the paper's expected numbers
#                     (benchmarks/smoke-expected.tsv). Results: results/smoke/
# examples:
#   bash scripts/run_experiments_paper-tables.sh all
#   bash scripts/run_experiments_paper-tables.sh pbv:cvc5-pbv,cvc5+rr exp:cvc5-exp
#   bash scripts/run_experiments_paper-tables.sh --dry-run cav26:cvc5-pbv-enum oopsla
#   bash scripts/run_experiments_paper-tables.sh --time-limit=300 exp
#   bash scripts/run_experiments_paper-tables.sh --smoke-test
# Run scripts/setup.sh once before (unpacks the benchmarks into data/ and prepares bin/).
#
# Results:  results/<table>/<config>/<set>/...   (override with WD_BASE=...)
# Analyze:  see README.md
#
# cvc5 / PBV flags are the ones of run_experiments_all-new.sh (eva/paper-nov).

ART="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOLVERS_DIR="$ART/bin"
DATA_DIR="$ART/data"
TIME_LIMIT=60
TIME_LIMIT_SET=""   # set when --time-limit is given
MEM_LIMIT=""        # MB per run; "" = the runner's default (8000)
SMOKE=""
WD_BASE="${WD_BASE:-$ART/results}"
BACKEND=local
JOBS=""

############# benchmark sets
SET_PBV="pbv_alive pbv_ic pbv_icfb pbv_lemmas pbv_mut pbv_rewrite pbv_syrew pbv_QF_PBV_Single_bitwidth pbv_QF_PBV_multiple_bitwidth pbv_QF_PBV_two_bitwidth pbv_fvfp-book"
# pbvsolver (Pbv, SAT'25) does not parse the PBitVec sort (answers "unknown" at once):
# it runs on the old (_ BitVec k) versions of the 7 SAT'25 sets (no QF_PBV / fvfp-book version)
SET_PBV_SAT25="sat25_alive sat25_ic sat25_icfb sat25_lemmas sat25_mut sat25_rewrite sat25_syrew"
# exp table: two SAT'25 families -- exp_q_sat25 = exp_ic (quantified),
# exp_qf_sat25 = exp_mut exp_rewrite exp_syrew exp_alive exp_lemmas (quantifier-free)
SET_EXP="exp_LoAT exp_PURRS exp_q_sat25 exp_qf_sat25"
# the per-source exp sets, still used by Table 14 (exp-reducer)
SET_EXP_SPLIT="exp_LoAT exp_PURRS exp_alive exp_ic exp_lemmas exp_mut exp_rewrite exp_syrew"

# cav26, set-logic PBV (cvc5 and pbvsolver+ input)
SET_SMT2_PBV="cav26_Alive_smt2_pbv_multiwidth cav26_Alive_smt2_pbv_singlewidth cav26_Hydra_smt2_pbv_multiwidth cav26_Hydra_smt2_pbv_singlewidth"
SET_SMT2_PBV_MATCHED="cav26_Alive_smt2_pbv_multiwidth_bwlang_matched cav26_Alive_smt2_pbv_singlewidth_bwlang_matched cav26_Hydra_smt2_pbv_multiwidth_bwlang_matched cav26_Hydra_smt2_pbv_singlewidth_bwlang_matched cav26_Industry_smt2_pbv_multiwidth_bwlang_matched cav26_Industry_smt2_pbv_singlewidth_bwlang_matched cav26_ROVER_smt2_pbv_multiwidth_bwlang_matched cav26_ROVER_smt2_pbv_singlewidth_bwlang_matched"
SET_SMT2_PBV_UNMATCHED="cav26_Alive_smt2_pbv_multiwidth_bwlang_unmatched cav26_Alive_smt2_pbv_singlewidth_bwlang_unmatched cav26_Hydra_smt2_pbv_multiwidth_bwlang_unmatched cav26_Hydra_smt2_pbv_singlewidth_bwlang_unmatched"
SET_ONE_FILE_PBV="cav26_Alive_smt2_pbv_multiwidth cav26_Alive_smt2_pbv_singlewidth cav26_Hydra_smt2_one_file_pbv_multiwidth cav26_Hydra_smt2_one_file_pbv_singlewidth cav26_Industry_smt2_one_file_pbv_multiwidth cav26_Industry_smt2_one_file_pbv_singlewidth cav26_ROVER_smt2_one_file_pbv_multiwidth cav26_ROVER_smt2_one_file_pbv_singlewidth"
SET_CAV_ENUM="$SET_SMT2_PBV $SET_SMT2_PBV_MATCHED"          # enumeration encoding (cmpr-cav26.py --collapse)
SET_CAV_ITE="$SET_ONE_FILE_PBV $SET_SMT2_PBV_UNMATCHED"      # single-formula (ite) encoding
# cav26, bwlang (ParaBit input)
SET_BWLANG="cav26_Alive_bwlang_multiwidth cav26_Alive_bwlang_singlewidth cav26_Hydra_bwlang_multiwidth cav26_Hydra_bwlang_singlewidth cav26_Industry_bwlang_multiwidth cav26_Industry_bwlang_singlewidth cav26_ROVER_bwlang_multiwidth cav26_ROVER_bwlang_singlewidth"

# oopsla: the unbounded solvers and pbvsolver run on the OOPSLA'26 versions of the sets,
# pbvsolver+ / cvc5-pbv on ours
SET_OOPSLA="umbc_all_sext-zext-instcombine umbc_all_rover sat25_alive"
SET_OOPSLA_OURS="pbv_alive umbc_instcombine umbc_rover"

# exp-reducer (Table 14): "all 28312 benchmarks of this paper" -- the cvc5 input of every table,
# with the cav26 sets in the single-formula (ite) encoding
SET_EXP_REDUCER="$SET_PBV $SET_EXP_SPLIT exp_PURRS_with_axioms umbc_rover umbc_hero umbc_instcombine $SET_CAV_ITE"

# smoke test: a fixed sample of each PBV set (see benchmarks/smoke-expected.tsv)
SET_SMOKE=$(for s in $SET_PBV; do printf 'smoke_%s ' "$s"; done)

############# solver configurations (Table tab:config)
BASE="--nl-ext-tplanes --full-saturate-quant"
PIAND="--piand-lemmas=complement,mask,mask-sym,subset-trans,pow2-idiom"
EXP_CORE="--exp-solver=rewrites,lemmas,phasing --exp-preprocess=multiply --fermat-little-theorem"

F_CVC5="$BASE"                                                    # \confcvcbase
F_FERMAT="$BASE --fermat-little-theorem"                          # \confcvcfermat
F_MOD="$BASE --learned-rewrite-rules=int"                         # \confcvcmodred
F_PRE="$BASE --exp-preprocess=multiply"                           # \confcvcpre, Table 14 row mul
F_PRE_DIV="$BASE --exp-preprocess=div"                            # Table 14 row div
F_PRE_COMMON="$BASE --exp-preprocess=common"                      # Table 14 row common
F_EXP_NOPH="$BASE --exp-solver=rewrites,lemmas"                   # \confcvcplusexpnophase
F_PLUSEXP="$BASE --exp-solver=rewrites,lemmas,phasing"            # \confcvcplusexp
F_CVC5_EXP="$BASE $EXP_CORE --learned-rewrite-rules=int"          # \confcvcexp
F_RR="$BASE --pbv-rewrites"                                       # \confcvcexprr
F_LR="$BASE --learned-rewrite-rules=pbv"                          # \confcvcexplr
F_PIAND="$BASE $PIAND"                                            # \confcvcexppiandexists
F_CVC5_PBV="$BASE $EXP_CORE --learned-rewrite-rules=int,pbv $PIAND --pbv-rewrites"   # \confcvc
F_PBVS='--cvc5:"nl-ext-tplanes full-saturate-quant"'              # \confsat / \confsatplus

############# helpers
MODE=submit      # submit | dry | list
ONLY=""          # comma-separated configs to run in the current table ("" = all)

# run TABLE CONFIG EXECUTABLE "SOLVER-OPTIONS" "SETS" [TIME_LIMIT]
run () {
  if [ "$MODE" = list ]; then echo "  $2"; return; fi
  if [ -n "$ONLY" ] && [[ ",$ONLY," != *",$2,"* ]]; then return; fi
  local wd="$WD_BASE/$1/$2"
  local cmd
  if [ "$BACKEND" = slurm ]; then
    if [ -e "$wd" ]; then
      echo "SKIP $1/$2: $wd already exists (remove it to re-run)" >&2
      return
    fi
    cmd=(bash "$ART/scripts/submit-job.sh")
  else
    # local runs resume: benchmarks that already have a run.out are skipped
    cmd=(python3 "$ART/scripts/run_local.py" ${JOBS:+--jobs "$JOBS"})
  fi
  cmd+=("$3" --solver-options "$4" --benchmark-sets "$5" --time-limit "${6:-$TIME_LIMIT}" --working-dir "$wd")
  [ -n "$MEM_LIMIT" ] && cmd+=(--memory-limit "$MEM_LIMIT")
  echo "==> $1/$2"
  if [ "$MODE" = dry ]; then printf '%q ' "${cmd[@]}"; echo; return; fi
  # both runners look up benchmark_set_* in the current directory
  (cd "$DATA_DIR" && "${cmd[@]}")
}

usage () { sed -n '/^# usage:/,/^# Run scripts\/setup.sh/p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-1}"; }

############# tables
# tables/eval_pbv.tex -- PBV benchmarks, ablation of the T_PBV techniques
table_pbv () {
  run pbv pbvsolver      $SOLVERS_DIR/pbvsolver  "$F_PBVS"     "$SET_PBV_SAT25"
  run pbv pbvsolver+     $SOLVERS_DIR/pbvsolver+ "$F_PBVS"     "$SET_PBV"
  run pbv cvc5           $SOLVERS_DIR/cvc5       "$F_CVC5"     "$SET_PBV"
  run pbv cvc5-exp       $SOLVERS_DIR/cvc5       "$F_CVC5_EXP" "$SET_PBV"
  run pbv cvc5+rr        $SOLVERS_DIR/cvc5       "$F_RR"       "$SET_PBV"
  run pbv cvc5+lr        $SOLVERS_DIR/cvc5       "$F_LR"       "$SET_PBV"
  run pbv cvc5+piand     $SOLVERS_DIR/cvc5       "$F_PIAND"    "$SET_PBV"
  run pbv cvc5-pbv       $SOLVERS_DIR/cvc5       "$F_CVC5_PBV" "$SET_PBV"
}

# tables/eval_cav26.tex -- CAV'26 sets, enumeration and single-formula (ite) encodings
table_cav26 () {
  run cav26 parabit             $SOLVERS_DIR/parabit    ""            "$SET_BWLANG"
  run cav26 pbvsolver+-enum     $SOLVERS_DIR/pbvsolver+ "$F_PBVS"     "$SET_CAV_ENUM"
  run cav26 pbvsolver+-ite      $SOLVERS_DIR/pbvsolver+ "$F_PBVS"     "$SET_CAV_ITE"
  run cav26 cvc5-pbv-enum       $SOLVERS_DIR/cvc5       "$F_CVC5_PBV" "$SET_CAV_ENUM"
  run cav26 cvc5-pbv-ite        $SOLVERS_DIR/cvc5       "$F_CVC5_PBV" "$SET_CAV_ITE"
}

# tables/eval_exp.tex -- EIA benchmarks: SwInE vs. the cvc5 exp ablation
table_exp () {
  run exp swine-z3            $SOLVERS_DIR/exp.sh    "--solver z3"   "$SET_EXP"
  run exp swine-cvc5          $SOLVERS_DIR/exp.sh    "--solver cvc5" "$SET_EXP"
  run exp swine-z3-reimp      $SOLVERS_DIR/exp-z3.sh ""              "$SET_EXP"
  run exp cvc5                $SOLVERS_DIR/cvc5      "$F_CVC5"       "$SET_EXP"
  run exp cvc5+fermat         $SOLVERS_DIR/cvc5      "$F_FERMAT"     "$SET_EXP"
  run exp cvc5+mod-reducer    $SOLVERS_DIR/cvc5      "$F_MOD"        "$SET_EXP"
  run exp cvc5+pre            $SOLVERS_DIR/cvc5      "$F_PRE"        "$SET_EXP"
  run exp cvc5+exp-no-phasing $SOLVERS_DIR/cvc5      "$F_EXP_NOPH"   "$SET_EXP"
  run exp cvc5+exp            $SOLVERS_DIR/cvc5      "$F_PLUSEXP"    "$SET_EXP"
  run exp cvc5-exp            $SOLVERS_DIR/cvc5      "$F_CVC5_EXP"   "$SET_EXP"
}

# tables/eval_oopsla.tex -- unbounded solvers of OOPSLA'26
table_oopsla () {
  run oopsla unb-ric3   $SOLVERS_DIR/oopsla_solve.sh "$SOLVERS_DIR/unb-ric3" "$SET_OOPSLA"
  run oopsla unb-kind   $SOLVERS_DIR/oopsla_solve.sh "$SOLVERS_DIR/unb-kind" "$SET_OOPSLA"
  run oopsla pbvsolver  $SOLVERS_DIR/pbvsolver       "$F_PBVS"               "$SET_OOPSLA"
  run oopsla pbvsolver+ $SOLVERS_DIR/pbvsolver+      "$F_PBVS"               "$SET_OOPSLA_OURS"
  run oopsla cvc5-pbv   $SOLVERS_DIR/cvc5            "$F_CVC5_PBV"           "$SET_OOPSLA_OURS"
}

# main.tex Table 14 (tab:pre-reduce, appendix) -- choice of the representative for
# reducing exp-instances; rows --, div, common, mul (one total row per config)
table_exp-reducer () {
  run exp-reducer cvc5        $SOLVERS_DIR/cvc5 "$F_CVC5"       "$SET_EXP_REDUCER"   # row --
  run exp-reducer cvc5-div    $SOLVERS_DIR/cvc5 "$F_PRE_DIV"    "$SET_EXP_REDUCER"   # row div
  run exp-reducer cvc5-common $SOLVERS_DIR/cvc5 "$F_PRE_COMMON" "$SET_EXP_REDUCER"   # row common
  run exp-reducer cvc5-mul    $SOLVERS_DIR/cvc5 "$F_PRE"        "$SET_EXP_REDUCER"   # row mul
}

# --smoke-test -- partial tables/eval_pbv.tex: its 7 solver columns on the smoke sample
table_smoke () {
  run smoke pbvsolver+     $SOLVERS_DIR/pbvsolver+ "$F_PBVS"     "$SET_SMOKE"
  run smoke cvc5           $SOLVERS_DIR/cvc5       "$F_CVC5"     "$SET_SMOKE"
  run smoke cvc5-exp       $SOLVERS_DIR/cvc5       "$F_CVC5_EXP" "$SET_SMOKE"
  run smoke cvc5+rr        $SOLVERS_DIR/cvc5       "$F_RR"       "$SET_SMOKE"
  run smoke cvc5+lr        $SOLVERS_DIR/cvc5       "$F_LR"       "$SET_SMOKE"
  run smoke cvc5+piand     $SOLVERS_DIR/cvc5       "$F_PIAND"    "$SET_SMOKE"
  run smoke cvc5-pbv       $SOLVERS_DIR/cvc5       "$F_CVC5_PBV" "$SET_SMOKE"
}

smoke_test () {
  [ -n "$TIME_LIMIT_SET" ] || TIME_LIMIT=5
  MEM_LIMIT=2000            # the sample needs little memory; lets more runs go in parallel
  local s missing=""
  for s in $SET_SMOKE; do [ -f "$DATA_DIR/benchmark_set_$s" ] || missing=1; done
  if [ "$MODE" != dry ] && { [ -n "$missing" ] || [ ! -d "$SOLVERS_DIR" ]; }; then
    # the smoke archives are tiny (~15 KB in all): unpack only them, not the full sets
    bash "$ART/scripts/setup.sh" $SET_SMOKE || exit 1
  fi
  local start=$SECONDS
  table_smoke
  [ "$MODE" = dry ] && return
  echo
  echo "smoke test done in $((SECONDS - start)) s (time limit ${TIME_LIMIT}s, ${MEM_LIMIT} MB per run)"
  if [ "$BACKEND" = slurm ]; then
    echo "Slurm jobs submitted; when they finish:  python3 $ART/scripts/smoke_report.py $WD_BASE/smoke"
  else
    python3 "$ART/scripts/smoke_report.py" "$WD_BASE/smoke"
  fi
}

############# main
TABLES="pbv cav26 exp oopsla exp-reducer"
SEL=()
while [ $# -gt 0 ]; do
  case $1 in
    --dry-run) MODE=dry ;;
    --list)    MODE=list ;;
    --backend) shift; BACKEND=${1:-}
               [[ "$BACKEND" == local || "$BACKEND" == slurm ]] || { echo "--backend must be local or slurm" >&2; exit 1; } ;;
    --jobs)    shift; JOBS=${1:-}
               [[ "$JOBS" =~ ^[1-9][0-9]*$ ]] || { echo "--jobs needs a positive number" >&2; exit 1; } ;;
    --time-limit=*|--time-limit)
               if [ "$1" = --time-limit ]; then shift; TIME_LIMIT=${1:-}; else TIME_LIMIT=${1#--time-limit=}; fi
               [[ "$TIME_LIMIT" =~ ^[1-9][0-9]*$ ]] || { echo "--time-limit needs a positive number of seconds" >&2; exit 1; }
               TIME_LIMIT_SET=1 ;;
    --smoke-test) SMOKE=1 ;;
    -h|--help) usage 0 ;;
    -*)        echo "unknown option '$1'" >&2; usage ;;
    *)         SEL+=("$1") ;;
  esac
  shift
done

if [ "$MODE" = list ]; then
  for t in $TABLES; do echo "$t:"; table_$t; done
  exit 0
fi
if [ -n "$SMOKE" ]; then
  [ ${#SEL[@]} -eq 0 ] || { echo "--smoke-test takes no SELECTION" >&2; exit 1; }
  smoke_test
  exit 0
fi
[ ${#SEL[@]} -eq 0 ] && usage

# validate everything before submitting anything
for s in "${SEL[@]}"; do
  t=${s%%:*}
  [ "$t" = all ] && [ "$s" = all ] && continue
  [[ " $TABLES " == *" $t "* ]] || { echo "unknown table '$t' (tables: $TABLES)" >&2; exit 1; }
  if [[ "$s" == *:* ]]; then
    known=$(MODE=list; table_$t | tr -d ' ' | tr '\n' ',')
    IFS=, read -r -a cfgs <<< "${s#*:}"
    [ ${#cfgs[@]} -eq 0 ] && { echo "no configuration given in '$s'" >&2; exit 1; }
    for c in "${cfgs[@]}"; do
      [[ ",$known" == *",$c,"* ]] || { echo "unknown configuration '$c' in table '$t' (known: ${known%,})" >&2; exit 1; }
    done
  fi
done

if [ "$MODE" != dry ] && { [ ! -d "$SOLVERS_DIR" ] || ! ls "$DATA_DIR"/benchmark_set_* >/dev/null 2>&1; }; then
  echo "artifact not set up: run  bash $ART/scripts/setup.sh  first" >&2; exit 1
fi

for s in "${SEL[@]}"; do
  if [ "$s" = all ]; then
    ONLY=""; for t in $TABLES; do table_$t; done
    continue
  fi
  t=${s%%:*}
  if [[ "$s" == *:* ]]; then ONLY=${s#*:}; else ONLY=""; fi
  table_$t
done
