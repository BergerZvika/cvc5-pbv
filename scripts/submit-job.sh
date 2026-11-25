#!/bin/bash

color_blue="\e[94m"
color_green="\e[92m"
color_red="\e[91m"
color_default="\e[39m"

benchmark_sets_system=/barrett/scratch/benchmarks
benchmark_sets_user=$(pwd)

runexec_binary="runexec"
runexec_options="--read-only-dir / --overlay-dir /home"

# Cluster configuration
max_mem_quad=64000
max_mem_octa=128000

# Default options
default_time_limit=1200
default_memory_limit=8000
default_num_cpus=1
default_partition="p_zohar"

# QOS time limits
qos_normal_tlimit=1800                       # 30 min max
qos_max2_tlimit=$((4 * qos_normal_tlimit))   # 2 hours max
qos_max12_tlimit=$((24 * qos_normal_tlimit)) # 12 hours max


# Options
time_limit=$default_time_limit
use_wall_time=
memory_limit=$default_memory_limit
num_cpus=$default_num_cpus
qos=""
partition="$default_partition"
working_dir=""
solver_options=""
benchmark_sets=""
multi_argument=
max_jobs_per_node=
job_name=
dry_run=

re_numeric='^[0-9]+$'
original_cmd="$0 $(printf "%q " "$@")"


#
# Helper functions
#

function usage ()
{
echo -e "
usage: $0 [options] EXECUTABLE

positional arguments:
 EXECUTABLE                            solver binary

optional arguments:
 -h, --help                            show this help message and exit
 -l                                    list available benchmark sets
 -q QOS, --qos QOS                     use SLURM QOS group
 -p PART, --partition PART             use SLURM partition PART (default: $color_blue$default_partition$color_default)
 -t N, --time-limit N                  use time limit of N seconds CPU time
                                       (default: $color_blue$default_time_limit$color_default)
 -w, --wall-time                       use WALL time instead of CPU time
 -m N, --memory-limit N                use memory limit of N MB
                                       (default: $color_blue$default_memory_limit$color_default)
 -c N, --cpus N                        allocate N CPUs per job (default: $color_blue$default_num_cpus$color_default)
 -d DIR, --working-dir DIR             use working directory DIR
 -o \"OPTS\",
 --solver-options \"OPTS\"               run EXECUTABLE with options OPTS
 -b \"SET1 SET2 ...\",
 --benchmark-sets \"SET1 SET2 ...\"      run EXECUTABLE on benchmark sets
 -j N, --max-jobs-per-node N           restrict number of jobs per node to N
 -n NAME, --job-name NAME              use job name NAME
 --multi                               multi-argument jobs
 --dry-run                             dry run, do not submit jobs to SLURM
 --copy DIR                            copy directory DIR to working directory
"
}

function die ()
{
  echo -e "[${color_red}error${color_default}] $*" 1>&2
  exit 1
}

function warn ()
{
  echo -e "[${color_red}warn${color_default}] $*"
  exit 1
}

function info ()
{
  echo -e "[${color_green}info${color_default}] $*"
}

# Print available benchmark sets
function list_benchmark_sets ()
{
  benchmark_files="$*"
  echo -e "available benchmark sets:"
  cnt=1
  for f in $benchmark_files; do
    n=$(basename "$f")
    s=${n#benchmark_set_}
    num=$(wc -l "$f" | awk '{print $1}')

    d=$(dirname "$f")
    if [[ "$d" == "$benchmark_sets_system" ]]; then
      printf "  %5s $s ($num) [system]\n" "[$cnt]"
    else
      printf "  ${color_blue}%5s $s ($num) [user]${color_default}\n" "[$cnt]"
    fi
    ((cnt+=1))
  done

  echo
  echo "supported syntax:"
  echo -en "  numeric:   ${color_blue}1 2 3 10 11 12${color_default} | "
  echo -e "${color_blue}1..3 10..12${color_default}"
  echo -e "  names:     ${color_blue}non_incremental_QF_BV incremental_ABV${color_default}"
  echo -e "  wildcards: ${color_blue}non_incremental_QF_* incremental_*BV*${color_default}"
  echo
  info "all of the above syntax can be mixed"
}

#
# Find available system and user benchmark sets
#
find_paths="$benchmark_sets_user"
if [ -e "$benchmark_sets_system" ]; then
  find_paths="$find_paths $benchmark_sets_system"
fi
sets=$(find $find_paths -maxdepth 1 -type f -name 'benchmark_set_*' | sort)

[[ -z "$sets" ]] && \
  die "no benchmark sets found in " \
      "'$benchmark_sets_system' and '$benchmark_sets_user'"


#
# Option parsing
#

while [ $# -gt 0 ]
do
  case $1 in
    -h|--help)
      usage
      exit 1
      ;;
    -l)
      list_benchmark_sets "$sets"
      exit 0
      ;;
    --copy)
      shift
      copy_dir="$1"
      ;;
    -q|--qos)
      shift
      qos="$1"
      ;;
    -p|--partition)
      shift
      partition="$1"
      ;;
    -t|--time-limit)
      shift
      time_limit="$1"
      ;;
    -w|--wall-time)
      use_wall_time="yes"
      ;;
    -m|--memory-limit)
      shift
      memory_limit="$1"
      ;;
    -c|--cpus)
      shift
      num_cpus="$1"
      ;;
    -d|--working-dir)
      shift
      working_dir="$1"
      ;;
    -o|--solver-options)
      shift
      solver_options="$1"
      ;;
    -b|--benchmark-sets|--arguments)
      shift
      benchmark_sets="$1"
      ;;
    -j|--max-jobs-per-node)
      shift
      max_jobs_per_node="$1"
      ;;
    -n|--job-name)
      shift
      job_name="$1"
      ;;
    --multi)
      multi_argument="yes"
      ;;
    --dry-run)
      dry_run="yes"
      ;;
    -*)
      die "invalid option '$1'"
      ;;
    *)
      [[ -n "$solver" ]] && die "executable already set to '$solver'"
      solver="$1"
      ;;
  esac
  shift
done

# Check if current user is in the benchexec group
(getent group benchexec | grep -q "$(whoami)") || \
  die "Your user is not in the 'benchexec' group." \
      "Ask an admin on #cluster to add your user to the 'benchexec' group."

[ -z "$solver" ] && die "no executable specified"
[ ! -e "$solver" ] && die "executable '$solver' does not exist"
[ -d "$solver" ] && die "executable '$solver' is a directory"
[ ! -x "$solver" ] && die "executable '$solver' is not executable"

solver=$(readlink -f "$solver")
solver_name=$(basename "$solver")
info "using solver '$solver'"

[[ -n "$copy_dir" && ! -e "$copy_dir" ]] && \
  die "copy directory '$copy_dir' does not exist"

declare -A benchmark_list
declare -A benchmark_list_rev
declare -A benchmark_files
cnt=1
for f in $sets; do
  file_name=$(basename "$f")
  set_name=${file_name#benchmark_set_}
  benchmark_list[$cnt]=$set_name
  benchmark_list_rev[${set_name,,}]=$cnt
  benchmark_files[$cnt]=$f
  ((cnt+=1))
done

# Select benchmark sets
benchmark_indices=""
msg="no benchmarks selected"

# Allow bash range syntax {n..m} for selecting multiple benchmark sets
if [[ "$benchmark_sets" == *".."* ]]; then
  benchmark_sets="$(eval echo "$benchmark_sets")"
fi
IFS=" " read -r -a sets <<< "$benchmark_sets"
for bset in "${sets[@]}"; do
  if [[ "$bset" =~ $re_numeric ]]; then
    if (( bset >= 1 && bset < cnt)); then
      benchmark_indices="$benchmark_indices $bset"
      continue
    fi
  else
    regex="$bset"
    if [[ "$bset" == *"*"* ]]; then
      regex="${bset//\*/.*}" # Replace * with .* to have proper wildcard
      msg="no matching benchmark sets found with '$bset'"
    fi
    for s in "${benchmark_list[@]}"; do
      if [[ "$s" =~ ^$regex$ ]]; then
        s=${s,,}
        if [ -n "${benchmark_list_rev[$s]}" ]; then
          benchmark_indices="$benchmark_indices ${benchmark_list_rev[$s]}"
        fi
      fi
    done
    continue
  fi
done
[ -z "$benchmark_indices" ] && warn "$msg"

benchmark_sets=""
num_benchmark_sets=0
info "using benchmark set(s):"
for idx in $benchmark_indices; do
  file="${benchmark_files[$idx]}"
  info "  $file"
  benchmark_sets="$benchmark_sets $file"
  (( num_benchmark_sets++ ))
  [[ $(tail -c1 "$file" | wc -l) == 0 ]] && \
    die "Benchmark set file '$file' does not end with a newline"
done

#
# Check working directory
#
[ -z "$working_dir" ] && warn "no working directory specified"
[ -d "$working_dir" ] && warn "directory '$working_dir' already exists"
info "using directory '${working_dir}'"

#
# Configure solver options
#
[ -n "$solver_options" ] && info "using options '$solver_options'"

#
# Check partition
#
# case "$partition" in
#   quad|octa|all)
#     ;;
#   *)
#     warn "invalid partition '$partition' choose 'quad octa all'"
#     ;;
# esac
info "using partition '$partition'"

#
# Check time limit
#
if [[ "$time_limit" == "0" ]]; then
  warn "unlimited time limit not allowed"
elif [[ "$qos" == "normal" && "$time_limit" -gt "$qos_normal_tlimit" ]]; then
  warn "QOS '$qos' has a maximum time limit of $qos_normal_tlimit seconds"
elif [[ "$qos" == "max2" && "$time_limit" -gt "$qos_max2_tlimit" ]]; then
  warn "QOS '$qos' has a maximum time limit of $qos_max2_tlimit seconds"
elif [[ "$qos" == "max12" && "$time_limit" -gt "$qos_max12_tlimit" ]]; then
  warn "QOS '$qos' has a maximum time limit of $qos_max12_tlimit seconds"
fi
[[ ! $time_limit =~ $re_numeric ]] && \
  warn "time limit '$time_limit' is not a number"
info "using time limit '$time_limit'"

#
# Check memory limit
#

# Set default memory limit
[[ ! $memory_limit =~ $re_numeric ]] && \
  warn "space limit '$memory_limit' is not a number"
info "using memory limit of ${memory_limit}M"


# Maximum number of CPUs depends on selected partition
if [[ "$partition" == "octa" ]]; then
  num_virtual_cores=32
else
  num_virtual_cores=16
fi

#
# Check number of CPUs per job
#
max_num_cpus=$num_virtual_cores
[[ ! $num_cpus =~ $re_numeric ]] && warn "'$num_cpus' is not a number"
[[ $num_cpus -lt 1 || $num_cpus -gt $max_num_cpus ]] && \
  warn "number of CPUs must be between 1 and $max_num_cpus"

info "using $num_cpus CPUs"


#
# Select QOS based on time limit
#
if [ -z "$qos" ]; then
  if [[ "$time_limit" -le "$qos_normal_tlimit" ]]; then
    qos="normal"
  elif [[ "$time_limit" -le "$qos_max2_tlimit" ]]; then
    qos="max2"
  else
    qos="max12"
  fi
fi
info "using QOS '$qos'"


#
# Configure runexec options
#
if [[ $time_limit != 0 ]]; then
  if [ -z "$use_wall_time" ]; then
    runexec_options="$runexec_options --timelimit $time_limit"
  else
    runexec_options="$runexec_options --walltimelimit $time_limit"
  fi
fi
runexec_options="$runexec_options --memlimit ${memory_limit}MB"
info "using runexec options: $runexec_options"

#
# Compute maximum number of jobs per node
# This is done via memory allocation since this allows more fine grained
# allocation.
#
memory_limit_slurm=0
if [ -n "$max_jobs_per_node" ]; then
  if [ "$partition" == "quad" ]; then
    ((memory_limit_slurm=max_mem_quad/max_jobs_per_node))
    info "maximum number of jobs per node: $max_jobs_per_node"
  elif [ "$partition" == "octa" ]; then
    ((memory_limit_slurm=max_mem_octa/max_jobs_per_node))
    info "maximum number of jobs per node: $max_jobs_per_node"
  fi
fi
if ((memory_limit_slurm < memory_limit)); then
  memory_limit_slurm=$memory_limit
fi

[ -n "$dry_run" ] && info "Dry run, jobs were not submitted to SLURM!" && exit 0

#
# Setup working directory
#
mkdir -p "$working_dir"
working_dir="$(realpath "$working_dir")"

# Create options file
{
  echo "$original_cmd"
  echo

  if [ -z "$use_wall_time" ]; then
    echo "cpu time limit:  $time_limit"
  else
    echo "wall time limit: $time_limit"
  fi
  echo "memory limit:    $memory_limit"
  echo "command:         $solver_name $solver_options"
  echo "runexec:         $runexec_options"
  echo "qos:             $qos"
  echo "partition:       $partition"
  if [ -n "$max_jobs_per_node" ]; then
    echo "jobs per node:  $max_jobs_per_node"
  fi
} > "$working_dir/options"

#
# Setup binaries/scripts
#

# Copy solver binary
cp "$solver" "$working_dir"

# Copy contents of directory
[ -n "$copy_dir" ] && cp -a "$copy_dir/." "$working_dir/"

#
# Create array job for each benchmark set
#
for benchmark_set in $benchmark_sets; do
  set_name="$(basename "$benchmark_set")"
  set_name="${set_name#benchmark_set_}"
  working_dir_set="$working_dir/$set_name"
  mkdir -p "$working_dir_set"

  # Save benchmarks file, solver
  cp "$benchmark_set" "$working_dir_set/benchmarks"

  # Number of benchmark files = number of jobs in the array job
  ntasks=$(wc -l "$benchmark_set" | cut -d ' ' -f 1)

  # Single-argument script: benchmark set files contain an input file per line
  COMMAND=""
  if [ -z "$multi_argument" ]; then
    # Get most common prefix of all benchmark files
    prefix=$(
  python3 - <<EOF
from os.path import dirname, commonprefix
path = dirname(commonprefix(open('$benchmark_set').readlines()))
if path: print('{}/'.format(path))
EOF
    )
    WSUBDIR="\${ARGS#$prefix}"
  else
    WSUBDIR="slurm-\${SLURM_ARRAY_TASK_ID}"
  fi

  if [ -z "$COMMAND" ]; then
    COMMAND="$working_dir/$solver_name $solver_options"
    if [ -z "$multi_argument" ]; then
      COMMAND="$COMMAND \"\$ARGS\""
    else
      COMMAND="$COMMAND \$ARGS"
    fi
  fi

  # Create sbatch script
  SBATCH_SCRIPT="$working_dir_set/script.sh"

  cat > "$SBATCH_SCRIPT" << EOF
#!/bin/bash

#SBATCH -e /dev/null
#SBATCH -o /dev/null
#SBATCH -c $num_cpus
#SBATCH -a 1-$ntasks
#SBATCH --mem=${memory_limit_slurm}M
#SBATCH -D $working_dir
#SBATCH --partition=p_zohar
#SBATCH --account=ug_zohar

set -e -o pipefail

ARGS="\$(sed \${SLURM_ARRAY_TASK_ID}'q;d' $working_dir_set/benchmarks)"
LOGDIR="$working_dir_set/$WSUBDIR"
mkdir -p "\$LOGDIR"
out="\$LOGDIR/run.out"
OUTPUT="\$LOGDIR/output.log"

export ARGS
export OUTPUT
export LOGDIR
(
  echo "c host:       \$(hostname)"
  echo "c user:       \$(whoami)"
  echo "c PYTHONPATH:       \$PYTHONPATH"
  echo "c start:      \$(date)"
  echo "c arrayjobid: \${SLURM_ARRAY_JOB_ID}"
  echo "c jobid:      \${SLURM_JOB_ID}"
  echo "c command:    $COMMAND"
  echo "c args:       \$ARGS"

  $runexec_binary $runexec_options --dir "\$LOGDIR" --full-access-dir "\$LOGDIR" --output "\${OUTPUT}" -- $COMMAND

  echo "c done"
) > "\$out" 2>&1
EOF

  if [ -z "$job_name" ]; then
    job_name="$set_name"
  fi

  # Create sub shell, change working directory and execute script
  (cd "$working_dir_set" && exec sbatch --job-name="$job_name" ./script.sh)
done
