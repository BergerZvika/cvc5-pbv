#!/usr/bin/env python3
#
# cmpr: A tool for extracting and analyzing SAT/SMT/++ solver runs.
#
# Copyright (C) 2020  Mathias Preiner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, ArgumentTypeError
from itertools import zip_longest
import mmap
import os
import sys
import time
import json

import polars as pl

class CmprException(Exception):
    def __init__(self, msg):
        self.msg = msg

    def __str__(self):
        return "Error: {0:s}".format(self.msg)


CACHE_FILE_NAME = 'cmpr_cache.parquet'

RESULT_NONE = 'none'
RESULT_SAT = 'sat'
RESULT_UNSAT = 'unsat'
RESULT_UNKNOWN = 'unknown'
RESULT_SYNTH = 'synth'

STATUS_ERR = 'ee'
STATUS_OK = 'ok'
STATUS_MEM = 'mo'
STATUS_TIME = 'to'
STATUS_DIS = 'di'

# Data keys extracted from log files
KEY_DIR = 'directory'
KEY_CONFIG = 'config'
KEY_RESULT = 'result'
KEY_BENCHMARK = 'benchmark'
KEY_STATUS = 'status'
KEY_EXIT_CODE = 'exit_code'
KEY_EXIT_SIGNAL = 'exit_signal'
KEY_TIME_REAL = 'time_real'
KEY_TIME_CPU = 'time_cpu'
KEY_MEMORY = 'memory'
KEY_OUTPUT_LOG = 'output_log'

# Computed keys
KEY_GROUP = 'group'
KEY_SOLVED = 'solved'
KEY_SAT = 'sat'
KEY_UNSAT = 'unsat'
KEY_UNKNOWN = 'unknown'
KEY_SYNTH = 'synth'
KEY_TIMEOUT = 'timeout'
KEY_MEMOUT = 'memout'
KEY_ERROR = 'error'
KEY_DISAGR = 'disagr'
KEY_DIFF = 'diff'
KEY_UNIQ = 'uniq'
KEY_NSOLVED = 'nsolved'
KEY_TIME_SLOWDOWN = 'slowdown'
KEY_INCREMENTAL = 'incremental'
KEY_BEST = 'best'
KEY_UNSOLVED = 'unsolved'
KEY_PAR = 'par'

# Aggregate functions for keys
KEY_AGGS = [
    pl.col(KEY_SOLVED).sum(),
    pl.col(KEY_SAT).sum(),
    pl.col(KEY_UNSAT).sum(),
    pl.col(KEY_UNKNOWN).sum(),
    pl.col(KEY_UNSOLVED).sum(),
    pl.col(KEY_TIME_CPU).sum(),
    pl.col(KEY_TIME_REAL).sum(),
    pl.col(KEY_MEMORY).sum(),
    pl.col(KEY_TIMEOUT).sum(),
    pl.col(KEY_MEMOUT).sum(),
    pl.col(KEY_ERROR).sum(),
    pl.col(KEY_DISAGR).sum(),
    pl.col(KEY_UNIQ).sum(),
    pl.col(KEY_TIME_SLOWDOWN).mean(),
    pl.col(KEY_INCREMENTAL).sum(),
    pl.col(KEY_BEST).sum(),
    pl.col(KEY_PAR).sum(),
]

# Keys available for the user to specify for printing
AVAILABLE_KEYS = [
    KEY_RESULT,
    KEY_STATUS,
    KEY_EXIT_CODE,
    KEY_TIME_REAL,
    KEY_TIME_CPU,
    KEY_MEMORY,
    KEY_SOLVED,
    KEY_SAT,
    KEY_UNSAT,
    KEY_UNKNOWN,
    KEY_SYNTH,
    KEY_UNSOLVED,
    KEY_TIMEOUT,
    KEY_MEMOUT,
    KEY_ERROR,
    KEY_DISAGR,
    KEY_UNIQ,
    KEY_TIME_SLOWDOWN,
    KEY_PAR,
    KEY_BEST,
]

###############################################################################
### Parsers
###############################################################################


# Parser base class
class ValueParser:
    def key(self):
        raise NotImplementedError('key method not implemented')

    def match(self, line):
        raise NotImplementedError('match method not implemented')

    def extract(self, line):
        raise NotImplementedError('extract method not implemented')


class BenchmarkParser(ValueParser):
    def key(self):
        return KEY_BENCHMARK

    def match(self, line):
        return line.startswith(b'c args:')

    def extract(self, line):
        return line.split(b':', maxsplit=1)[1].strip().decode('utf-8')


class TerminationReasonParser(ValueParser):
    def key(self):
        return KEY_STATUS

    def match(self, line):
        return line.startswith(b'terminationreason=')

    def extract(self, line):
        # Possible values for terminationreason:
        #   https://github.com/sosy-lab/benchexec/blob/master/doc/run-results.md
        reason = str(line).split('=')[1].strip()
        if 'time' in reason:
            return STATUS_TIME
        elif 'memory' in reason:
            return STATUS_MEM
        return STATUS_ERR


class ExitCodeParser(ValueParser):
    def key(self):
        return KEY_EXIT_CODE

    def match(self, line):
        return line.startswith(b'returnvalue=')

    def extract(self, line):
        return int(line.split(b'=')[1])


class ExitSignalParser(ValueParser):
    def key(self):
        return KEY_EXIT_SIGNAL

    def match(self, line):
        return line.startswith(b'exitsignal=')

    def extract(self, line):
        return int(line.split(b'=')[1])


class TimeRealParser(ValueParser):
    def key(self):
        return KEY_TIME_REAL

    def match(self, line):
        return line.startswith(b'walltime=')

    def extract(self, line):
        return float(line.split(b'=')[1].rstrip(b's'))


class TimeCpuParser(ValueParser):
    def key(self):
        return KEY_TIME_CPU

    def match(self, line):
        return line.startswith(b'cputime=')

    def extract(self, line):
        return float(line.split(b'=')[1].rstrip(b's'))


class MemoryParser(ValueParser):
    def key(self):
        return KEY_MEMORY

    def match(self, line):
        return line.startswith(b'memory=')

    def extract(self, line):
        # Convert to MB
        return float(line.split(b'=')[1].rstrip(b'B')) / (1000 * 1000)


class ResultParser(ValueParser):
    def __init__(self):
        self.results = dict()

    def key(self):
        return KEY_RESULT

    def match(self, line):
        return line in self.results

    def extract(self, line):
        return self.results[line]


class SATResultParser(ResultParser):
    def __init__(self):
        ResultParser.__init__(self)
        self.results.update({
            b's SATISFIABLE': RESULT_SAT,
            b's UNSATISFIABLE': RESULT_UNSAT,
        })


class SMTResultParser(ResultParser):
    def __init__(self):
        ResultParser.__init__(self)
        self.results.update({
            b'sat': RESULT_SAT,
            b'unsat': RESULT_UNSAT,
            b'unknown': RESULT_UNKNOWN
        })


class AIGERResultParser(ResultParser):
    def __init__(self):
        ResultParser.__init__(self)
        self.results.update({
            b'0': RESULT_UNSAT,
            b'1': RESULT_SAT,
            b'2': RESULT_UNKNOWN
        })


class TPTPResultParser(ResultParser):
    def __init__(self):
        ResultParser.__init__(self)
        self.results.update({
            b'GaveUp': RESULT_UNKNOWN,
            b'Theorem': RESULT_UNSAT,
            b'ContradictoryAxioms': RESULT_UNSAT,
            b'Unsatisfiable': RESULT_UNSAT,
            b'CounterSatisfiable': RESULT_SAT,
            b'Satisfiable': RESULT_SAT
        })

    def match(self, line):
        l = line.split()
        try:
            i = l.index(b'status')
            return l[i + 1] in self.results
        except ValueError:
            return False

    def extract(self, line):
        l = line.split()
        try:
            i = l.index(b'status')
            return self.results[l[i + 1]]
        except ValueError:
            return RESULT_NONE


class SyGuSResultParser(ResultParser):
    def match(self, line):
        return line.startswith(b'(define-fun')

    def extract(self, line):
        return RESULT_SYNTH


# Registered value parsers

OUTPUT_LOG_PARSERS = []
RUN_OUT_PARSERS = [
    BenchmarkParser(),
    TerminationReasonParser(),
    ExitCodeParser(),
    ExitSignalParser(),
    TimeRealParser(),
    TimeCpuParser(),
    MemoryParser(),
]

def register_output_parser(parser, agg = None):
    global OUTPUT_LOG_PARSERS, AVAILABLE_KEYS
    OUTPUT_LOG_PARSERS.append(parser)
    AVAILABLE_KEYS.append(parser.key())
    if agg is not None:
        KEY_AGGS.append(agg)
    else:
        KEY_AGGS.append(pl.col(parser.key()).sum())

def register_run_parser(parser, agg = None):
    global RUN_OUT_PARSERS, AVAILABLE_KEYS
    RUN_OUT_PARSERS.append(parser)
    AVAILABLE_KEYS.append(parser.key())
    if agg:
        KEY_AGGS.append(agg)
    else:
        KEY_AGGS.append(pl.col(parser.key()).sum())

###############################################################################
### Argument parsing
###############################################################################


def help_available_columns():
    return 'Available columns:\n  {}'.format('\n  '.join(AVAILABLE_KEYS))

def parse_par_tuple(x):
    try:
        n, time_limit = map(int, x.split(','))
        return n * time_limit
    except:
        raise ArgumentTypeError("Arguments for --par must be N,TIME_LIMIT")

def parse_and_check_arguments(args):
    global g_args, RUN_OUT_PARSERS

    ap = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter,
                        epilog='availabe values for column: {{ {} }}, '.format(
                            ', '.join(sorted(AVAILABLE_KEYS))))
    ap.add_argument(
        'dirs',
        nargs='*',
        help='run directories to compare, not required with --smt-comp-json')
    ap.add_argument('-v',
                    '--verbose',
                    dest='verbose',
                    action='store_true',
                    default=False,
                    help='enable verbose output')
    ap.add_argument('-c',
                    dest='columns',
                    metavar='COLUMN[,COLUMN ...]',
                    help='select columns to print')
    ap.add_argument('--full-path',
                    dest='show_full_path',
                    default=False,
                    action='store_true',
                    help='show full path instead of benchmark name')
    ap.add_argument('--ignore-cache',
                    action='store_true',
                    dest='ignore_cache',
                    help='overwrite cache file')
    ap.add_argument('--ignore-dis',
                    action='store_true',
                    dest='ignore_disagreement',
                    help='ignore disagreements')
    ap.add_argument(
        '--no-strict',
        dest='no_strict', default=False, action='store_true',
        help='do not count every non-(sat/unsat/unknown/timeout/memout) ' \
             'result as error'
    )
    ap.add_argument('--time-limit',
                    dest='time_limit',
                    metavar='SECONDS',
                    type=int,
                    help='use time out')
    ap.add_argument('--penalty',
                    metavar='SECONDS',
                    type=int,
                    help='CPU time penalty for memory out/error')
    ap.add_argument('--par',
                    metavar='N,TIME_LIMIT',
                    type=parse_par_tuple,
                    help='PAR-N scoring with a TIME_LIMIT seconds')
    ap.add_argument('--compare-real',
                    action='store_true',
                    default=False,
                    help='compare real time instead of CPU time')

    ap.add_argument('--vbs',
                    action='store_true',
                    help='compute virtual best solver')
    ap.add_argument('--slowdown',
                    type=str,
                    default='',
                    nargs='?',
                    help='compute slowdown w.r.t. to given solver (directory)')

    ag = ap.add_argument_group('SMT-COMP results')
    ag.add_argument('--smt-comp-json',
                    type=str,
                    metavar='JSON',
                    help='read SMT-COMP results from JSON file')
    ag.add_argument('--smt-comp-solvers',
                    type=str,
                    metavar='solver1,solver2,...',
                    help='display specific solver results')

    # Grouping of results
    ag = ap.add_argument_group('Grouping results')
    ag.add_argument('-g',
                    dest='grouped',
                    action='store_const',
                    const=-1,
                    help='group benchmarks by lowest subdirectory')
    ag.add_argument('-G',
                    dest='grouped',
                    type=int,
                    nargs='?',
                    const=1,
                    metavar='K',
                    help='if (+), group benchmarks by top K directories; ' +
                         'if (-), by the bottom-K')
    ag.add_argument('-t',
                    dest='grouped',
                    action='store_const',
                    const=0,
                    help='generate totals')

    desc = """
        Filter based on column values, e.g., -q "time_cpu>=10" lists only
        benchmarks that required at least 10 seconds to solve.
        Availale keys: [{}]
        Supported operators: [{}]
    """.format(', '.join(AVAILABLE_KEYS),
               ', '.join(['>=', '<=', '>', '<', '=']))
    ag = ap.add_argument_group('Filtering based on values', desc)
    ag.add_argument('-q',
                    dest='queries',
                    metavar='QUERY',
                    action='append',
                    help='filter results based on column values')

    # Filer based on benchmarks
    ag = ap.add_argument_group('Filtering benchmarks')
    ag.add_argument('-f',
                    dest='filter',
                    metavar='REGEX',
                    action='append',
                    help='filter benchmarks matching REGEX')
    ag.add_argument('-e',
                    dest='exclude',
                    metavar='REGEX',
                    action='append',
                    help='exclude benchmarks matching REGEX')

    # Filter based on status
    ag = ap.add_argument_group('Filtering based on status')
    ag.add_argument('--show-sat',
                    dest='show_sat',
                    default=False,
                    action='store_true',
                    help='show satisfiable instances')
    ag.add_argument('--show-no-sat',
                    dest='show_no_sat',
                    default=False,
                    action='store_true',
                    help='don\'t show satisfiable instances"')
    ag.add_argument('--show-unsat',
                    dest='show_unsat',
                    default=False,
                    action='store_true',
                    help='show unsatisfiable instances')
    ag.add_argument('--show-no-unsat',
                    dest='show_no_unsat',
                    default=False,
                    action='store_true',
                    help='don\'t show unsatisfiable instances')
    ag.add_argument('--show-unknown',
                    dest='show_unknown',
                    default=False,
                    action='store_true',
                    help='show unknown instances')
    ag.add_argument('--show-no-unknown',
                    dest='show_no_unknown',
                    default=False,
                    action='store_true',
                    help='don\'t show unknown instances')
    ag.add_argument('--show-time',
                    dest='show_time',
                    default=False,
                    action='store_true',
                    help='show timeouts only')
    ag.add_argument('--show-mem',
                    dest='show_mem',
                    action='store_true',
                    default=False,
                    help='show memory outs only')
    ag.add_argument('--show-err',
                    dest='show_err',
                    action='store_true',
                    help='show errors only')
    ag.add_argument('--show-ok',
                    dest='show_ok',
                    action='store_true',
                    help='show non-errors only')
    ag.add_argument('--show-dis',
                    dest='show_dis',
                    action='store_true',
                    help='show disagreements only')
    ag.add_argument('--show-common',
                    dest='show_common',
                    action='store_true',
                    help='show commonly solved instances only')
    ag.add_argument('--show-solved',
                    dest='show_solved',
                    action='store_true',
                    help='show solved instances only')
    ag.add_argument('--show-unsolved',
                    dest='show_unsolved',
                    action='store_true',
                    help='show unsolved instances only')
    ag.add_argument('--show-diff',
                    dest='show_diff',
                    action='store_true',
                    help='show benchmarks with different status only')
    ag.add_argument('--show-unique',
                    dest='show_unique',
                    action='store_true',
                    help='show uniquely solved benchmarks only')
    ag.add_argument('--show-intersection',
                    dest='show_intersection',
                    action='store_true',
                    help='show intersection of benchmarks only')
    ag.add_argument('--summarize-errors',
                    action='store_true',
                    help='Print grouped summary of detected errors')

    # Output formats
    ag = ap.add_argument_group('Output formats')
    ag.add_argument('--html',
                    dest='html',
                    action='store_true',
                    help='generte HTML table')
    ag.add_argument('--csv',
                    dest='csv',
                    action='store_true',
                    help='generate CSV')
    ag.add_argument('--latex',
                    dest='latex',
                    action='store_true',
                    help='generate LaTeX table')

    # Alternative compare modes
    ag = ap.add_argument_group('Alternative modes')
    ag.add_argument('--aiger',
                    dest='aiger',
                    action='store_true',
                    help='AIGER mode')
    ag.add_argument('--sat', dest='sat', action='store_true', help='SAT mode')
    ag.add_argument('--synth',
                    dest='synth',
                    action='store_true',
                    help='SyGuS mode')
    ag.add_argument('--tptp',
                    dest='tptp',
                    action='store_true',
                    help='TPTP mode')

    g_args = ap.parse_args(args)

    if g_args.summarize_errors and g_args.grouped is not None:
        raise CmprException('--summarize-errors and -t, -g, -G not compatible')

    # Do not use a set here as the order of directories should be preserved
    unique_dirs = []
    for d in g_args.dirs:
        if not os.path.isdir(d):
            raise CmprException("Directory '{}' does not exist.".format(d))
        if d not in unique_dirs:
            unique_dirs.append(d.rstrip('/'))
    g_args.dirs = unique_dirs

    if g_args.slowdown and g_args.slowdown not in unique_dirs:
        raise CmprException(
                f'Invalid directory {g_args.slowdown} specified for --slowdown')

    if not g_args.dirs and not g_args.smt_comp_json:
        raise CmprException('No directories to compare specified.')

    # Setup columns to print
    if g_args.columns:
        g_args.columns = g_args.columns.split(',')
        invalid_columns = set(g_args.columns).difference(set(AVAILABLE_KEYS))
        if invalid_columns:
            invalid_columns = ','.join(invalid_columns)
            raise CmprException("Columns '{}' not available.\n{}".format(
                invalid_columns, help_available_columns()))

    if g_args.queries:
        queries = []
        for query in g_args.queries:
            relop = None
            for x in ['>=', '<=', '>', '<', '=']:
                if x in query:
                    relop = x
                    break

            if not relop:
                raise CmprException(
                    "Invalid query statement '{}'".format(query))

            t = query.split(relop)
            if len(t) != 2:
                raise CmprException(
                    "Invalid query statement '{}'".format(query))
            key, value = t
            if key not in AVAILABLE_KEYS:
                raise CmprException(
                    "Invalid key '{}' in query statement.\n{}".format(
                        key, help_available_columns()))
            queries.append((key, relop, value))
            g_args.queries = queries

    # Determine result parser
    if g_args.aiger:
        register_output_parser(AIGERResultParser(), pl.col(KEY_RESULT).count())
    elif g_args.sat:
        register_output_parser(SATResultParser(), pl.col(KEY_RESULT).count())
    elif g_args.tptp:
        register_output_parser(TPTPResultParser(), pl.col(KEY_RESULT).count())
    elif g_args.synth:
        register_output_parser(SyGuSResultParser(), pl.col(KEY_RESULT).count())
    else:
        register_output_parser(SMTResultParser(), pl.col(KEY_RESULT).count())


###############################################################################
### Data extraction
###############################################################################


def smtcomp_convert_result(x):
    if x == 'sat':
        return [RESULT_SAT]
    elif x == 'unsat':
        return [RESULT_UNSAT]
    return [RESULT_UNKNOWN]


def read_smt_comp_json(results_json):

    # Check if cache file is present
    cache_file = '{}.{}'.format(results_json, CACHE_FILE_NAME)
    if not g_args.ignore_cache and os.path.isfile(cache_file):
        return pl.read_parquet(cache_file)


    # Collect all keys from the value parsers
    all_keys = [f.key() for f in OUTPUT_LOG_PARSERS]
    all_keys.extend(f.key() for f in RUN_OUT_PARSERS)
    all_keys.extend([KEY_OUTPUT_LOG, KEY_CONFIG, KEY_DIR])
    rows = dict((k, []) for k in all_keys)

    with open(results_json) as f:
        data = json.load(f)

        for result in data['results']:
            file = result['file']
            benchmark =  os.path.join(file['logic'],
                                      *file['family'],
                                      file['name'])
            rows[KEY_BENCHMARK].append(benchmark)
            rows[KEY_CONFIG].append(result['solver'])
            rows[KEY_MEMORY].append(float(result['memory_usage'])/(1000*1000))
            rows[KEY_TIME_CPU].append(float(result['cpu_time']))
            rows[KEY_TIME_REAL].append(float(result['wallclock_time']))
            rows[KEY_RESULT].append(smtcomp_convert_result(result['result']))
            rows[KEY_STATUS].append(STATUS_OK)
            
        # Fill missing keys with None
        nrows = len(rows[KEY_BENCHMARK])
        fill = [None] * nrows
        for k in all_keys:
            if len(rows[k]) == 0:
                rows[k] = fill
            else:
                assert len(rows[k]) == nrows

    df = pl.DataFrame(rows)
    df.write_parquet(cache_file)

    return df


def extract_data(full_path, filters):

    data = dict((f.key(), []) if f.key() == KEY_RESULT else
                (f.key(), None) for f in filters)
    if os.stat(full_path).st_size > 0:
        used_filters = set()
        with open(full_path, 'rb') as infile:
            mm = mmap.mmap(infile.fileno(), 0, access=mmap.ACCESS_READ)
            for line in iter(mm.readline, b''):
                line = line.strip()

                if len(used_filters) == len(filters):
                    break

                for f in filters:
                    k = f.key()
                    # Value already extracted for current file
                    if k in used_filters:
                        continue

                    if not f.match(line):
                        continue

                    val = f.extract(line)

                    # Multiple results possible in case of incremental runs
                    if k != KEY_RESULT:
                        used_filters.add(k)

                    if k == KEY_RESULT:
                        data[k].append(val)
                    else:
                        assert data[k] == None
                        data[k] = val

    return data


def load_cache(dir):
    global g_args

    if g_args.ignore_cache:
        return None

    cache_file_path = os.path.join(dir, CACHE_FILE_NAME)
    if not os.path.isfile(cache_file_path):
        return None
    return pl.read_parquet(cache_file_path)


def save_cache(dir, df):
    df.write_parquet(os.path.join(dir, CACHE_FILE_NAME))


def read_data():
    dfs = []

    # Collect all keys from the value parsers
    all_keys = [f.key() for f in OUTPUT_LOG_PARSERS]
    all_keys.extend(f.key() for f in RUN_OUT_PARSERS)
    all_keys.extend([KEY_OUTPUT_LOG, KEY_CONFIG, KEY_DIR])

    for d in g_args.dirs:
        # Load cached data
        df = load_cache(d)
        if df is not None:
            # Update config and directory name in case directory was renamed
            df = df.with_columns(
                    pl.lit(d).alias(KEY_CONFIG),
                    pl.lit(d).alias(KEY_DIR)
                )
            dfs.append(df)
            continue

        rows = dict((k, []) for k in all_keys)

        # Extract data from all log files in all subdirectories.
        # Directory structure is as follows:
        # benchmark_set/
        #   family/
        #    ...
        #     benchmark/
        #       output.log
        #       run.out
        for root, _, files in os.walk(d):

            if 'run.out' not in files:
                continue

            if 'output.log' not in files:
                raise CmprException("output.log missing in '{}'".format(root))

            output_log = os.path.join(root, 'output.log')
            run_log = os.path.join(root, 'run.out')

            data = extract_data(run_log, RUN_OUT_PARSERS)
            data[KEY_CONFIG] = d
            data[KEY_DIR] = d
            data[KEY_OUTPUT_LOG] = output_log

            # If benchmark couldn't be found use relative path in 'd'
            if not data[KEY_BENCHMARK]:
                data[KEY_BENCHMARK] = root[len(d):]
            if not data[KEY_STATUS]:
                data[KEY_STATUS] = STATUS_OK
            if not data[KEY_EXIT_SIGNAL]:
                data[KEY_EXIT_SIGNAL] = 0

            for k, v in data.items():
                rows[k].append(v)
            data = extract_data(output_log, OUTPUT_LOG_PARSERS)
            for k, v in data.items():
                rows[k].append(v)

        df = pl.DataFrame(rows)
        dfs.append(df)
        save_cache(d, df)

    return pl.concat(dfs, how='vertical')


###############################################################################
### Result processing
###############################################################################


def filter_query(df):

    if not g_args.queries:
        return df

    filters = []
    for (key, relop, value) in g_args.queries:
        # 'key' may needs to be computed in process_data, try again afterwards
        if key not in df.schema:
            continue

        value = pl.lit(value).cast(df.schema[key])
        if relop == '>=':
            flt = pl.col(key) >= value
        elif relop == '<=':
            flt = pl.col(key) <= value
        elif relop == '>':
            flt = pl.col(key) > value
        elif relop == '<':
            flt = pl.col(key) < value
        else:
            assert relop == '='
            flt = pl.col(key) == value

        # Only remove benchmark if query returns false for all configurations
        filters.append(flt.any().over(KEY_BENCHMARK))

    if filters:
        return df.filter(filters)
    return df


def prefilter_results(df):

    if g_args.smt_comp_solvers:
        solvers = g_args.smt_comp_solvers.split(',')
        df = df.filter(pl.col(KEY_CONFIG).is_in(solvers))

    if g_args.filter:
        # All filters must match
        for pattern in g_args.filter:
            df = df.filter(pl.col(KEY_BENCHMARK).str.contains(pattern))

    if g_args.exclude:
        # Remove all matches
        df = df.filter(~pl.col(KEY_BENCHMARK).str.contains_any(g_args.exclude))

    df = filter_query(df)

    return df


def filter_results(df):
    global g_args

    # Show unsolved benchmarks
    if g_args.show_unsolved:
        df = df.filter(pl.col(KEY_NSOLVED) == 0)

    # Show solved benchmarks
    if g_args.show_solved:
        df = df.filter(pl.col(KEY_SOLVED) > 0)

    # Filter based on result sat, unsat, unknown
    key = None
    if g_args.show_sat:
        key = KEY_SAT
    elif g_args.show_unsat:
        key = KEY_UNSAT
    elif g_args.show_unknown:
        key = KEY_UNKNOWN
    if key:
        df = df.filter(pl.col(key) == 1)

    # Exclude sat/unsat/unknown benchmarks
    no_keys = []
    if g_args.show_no_sat:
        no_keys.append(KEY_SAT)

    if g_args.show_no_unsat:
        no_keys.append(KEY_UNSAT)

    if g_args.show_no_unknown:
        no_keys.append(KEY_UNKNOWN)

    if no_keys:
        for k in no_keys:
            df = df.filter(pl.col(k) == 0)

    # Filter based on status ok, mem, err, time, dis
    status = None
    if g_args.show_err:
        status = STATUS_ERR
    elif g_args.show_mem:
        status = STATUS_MEM
    elif g_args.show_ok:
        status = STATUS_OK
    elif g_args.show_time:
        status = STATUS_TIME
    elif g_args.show_dis:
        status = STATUS_DIS
    if status:
        df = df.filter(pl.col(KEY_STATUS) == status)

    nconfigs = df.select(KEY_CONFIG).unique().count()

    # Show benchmarks that could not be solved by all solvers
    if g_args.show_diff:
        df = df.filter(
                (pl.col(KEY_NSOLVED) > 0) & (pl.col(KEY_NSOLVED) != nconfigs)
             )

    # Show commonly solved benchmarks
    if g_args.show_common:
        df = df.filter(pl.col(KEY_NSOLVED) == nconfigs)

    # Show only intersection of benchmarks
    if g_args.show_intersection:
        df = df.filter(
                pl.col(KEY_BENCHMARK).count().over(KEY_BENCHMARK) == nconfigs)

    # Show uniquely solved benchmarks
    if g_args.show_unique:
        df = df.filter(pl.col(KEY_UNIQ) > 0)

    return df


def get_common_path_prefix_len(df):
    benchmarks = list(df.select(KEY_BENCHMARK).unique()[KEY_BENCHMARK])

    if not benchmarks:
        return ''

    benchmark = next(iter(benchmarks))

    if len(benchmarks) == 1:
        prefix = os.path.dirname(benchmark)
    else:
        prefix = os.path.commonpath(list(benchmarks))

    prefix_len = len(prefix)
    if benchmark[prefix_len] == '/':
        prefix_len += 1
    return prefix_len


def result_to_string(results: pl.Series):
    str_results = {
        RESULT_NONE: 'none',
        RESULT_SAT: 'sat',
        RESULT_UNSAT: 'unsat',
        RESULT_UNKNOWN: 'unknown',
        RESULT_SYNTH: 'synth',
    }

    if results.is_empty():
        return RESULT_NONE

    return ','.join(str_results.get(r, RESULT_NONE) for r in results)


def agg_disagr(x):
    results = zip_longest(*list(x), fillvalue=RESULT_UNKNOWN)
    for r in results:
        if RESULT_SAT in r and RESULT_UNSAT in r:
            return 1
    return 0


def process_data(df):

    psize = get_common_path_prefix_len(df)
    unique_configs = list(df.select(KEY_CONFIG).unique()[KEY_CONFIG])

    if not g_args.show_full_path:
        df = df.with_columns(
                pl.col(KEY_BENCHMARK).str.slice(psize).alias(KEY_BENCHMARK))

    if g_args.compare_real:
        time_key = KEY_TIME_REAL
    else:
        time_key = KEY_TIME_CPU

    # Reset timeout if given via g_args.time_limit
    if g_args.time_limit:
        time_limit = g_args.time_limit
        df = df.with_columns(
                pl.when(pl.col(time_key) >= time_limit)
                  .then(pl.lit(time_limit))
                  .otherwise(time_key)
                  .alias(time_key)
             ).with_columns(
                pl.when(pl.col(time_key) >= time_limit)
                  .then(pl.lit(STATUS_TIME))
                  .otherwise(KEY_STATUS)
                  .alias(KEY_STATUS),
                pl.when(pl.col(time_key) >= time_limit)
                  .then([])
                  .otherwise(KEY_RESULT)
                  .alias(KEY_RESULT),
             )

    # Determine solved, sat, unsat, and unknown results
    keys = [KEY_SAT, KEY_UNSAT, KEY_UNKNOWN]
    results = [RESULT_SAT, RESULT_UNSAT, RESULT_UNKNOWN]
    if g_args.synth:
        keys.append(KEY_SYNTH)
        results.append(RESULT_SYNTH)
    for k, r in zip(keys, results):
        df = df.with_columns(pl.col(KEY_RESULT).list.count_matches(r).alias(k))
    if g_args.synth:
        solved = pl.col(KEY_SYNTH)
    else:
        solved = pl.col(KEY_SAT) + pl.col(KEY_UNSAT)
    df = df.with_columns(solved.alias(KEY_SOLVED))

    # Compute status columns
    col_status = pl.col(KEY_STATUS)
    df = df.with_columns(
            (col_status == STATUS_TIME).cast(pl.Int32).alias(KEY_TIMEOUT),
            (col_status == STATUS_MEM).cast(pl.Int32).alias(KEY_MEMOUT),
            (col_status == STATUS_ERR).cast(pl.Int32).alias(KEY_ERROR),
        )

    # Set status disagreement
    if g_args.ignore_disagreement:
        df = df.with_columns(pl.lit(0).alias(KEY_DISAGR))
    else:
        df = df.with_columns(
            pl.col(KEY_RESULT)
              .map_elements(agg_disagr, return_dtype=pl.Int64)
              .over(KEY_BENCHMARK)
              .alias(KEY_DISAGR)
        ).with_columns(
            pl.when(pl.col(KEY_DISAGR) == 1)
              .then(pl.lit(STATUS_DIS))
              .otherwise(pl.col(KEY_STATUS))
              .alias(KEY_STATUS)
        )

    # All non-sat/unsat/unknown/timeout/memout/disagreement results are
    # considered as error in strict mode.
    if not g_args.no_strict:
        cond = (pl.col(KEY_SAT) + pl.col(KEY_UNSAT) + pl.col(KEY_UNKNOWN) +
                pl.col(KEY_TIMEOUT) + pl.col(KEY_MEMOUT) +
                pl.col(KEY_DISAGR)) == 0
        df = df.with_columns(
                pl.when(cond)
                  .then(pl.lit(STATUS_ERR))
                  .otherwise(pl.col(KEY_STATUS)).alias(KEY_STATUS),
                pl.when(cond)
                  .then(1)
                  .otherwise(pl.col(KEY_ERROR)).alias(KEY_ERROR)
            )

    # If runexec reports an exit signal and it is not a timeout or memout
    # the binary probably terminated abnormally.
    abnormal_exit = ((pl.col(KEY_TIMEOUT) + pl.col(KEY_MEMOUT)
                      + pl.col(KEY_DISAGR)) == 0) \
                    & (pl.col(KEY_EXIT_SIGNAL) != 0)
    df = df.with_columns(
            pl.when(abnormal_exit)
              .then(pl.lit(STATUS_ERR))
              .otherwise(pl.col(KEY_STATUS)).alias(KEY_STATUS),
            pl.when(abnormal_exit)
              .then(pl.lit(1))
              .otherwise(pl.col(KEY_ERROR)).alias(KEY_ERROR)
         )

    # Set CPU time penalty for memory outs and errors
    if g_args.penalty:
        cond_penalty = (pl.col(KEY_MEMOUT) + pl.col(KEY_ERROR)
                        + pl.col(KEY_UNKNOWN)) > 0
        df = df.with_columns(pl.when(cond_penalty)
                               .then(pl.lit(g_args.penalty))
                               .otherwise(pl.col(time_key))
                               .alias(time_key))

    if g_args.par:
        cond_par = ((pl.col(KEY_MEMOUT) + pl.col(KEY_ERROR)
                    + pl.col(KEY_UNKNOWN)) + pl.col(time_key) > 0)

        df = df.with_columns(pl.when(cond_par)
                               .then(pl.lit(g_args.par))
                               .otherwise(pl.col(time_key)
                               .alias(KEY_PAR)))
    else:
        df = df.with_columns(pl.lit(0).alias(KEY_PAR))



    # Determine if we got multiple results per file
    df = df.with_columns((pl.col(KEY_SOLVED) > 1).alias(KEY_INCREMENTAL))

    # Determine number of solvers that sovled specific benchmark
    df = df.with_columns(
            pl.col(KEY_SOLVED).sum().over(KEY_BENCHMARK).alias(KEY_NSOLVED)
         )

    # Determine uniquely solved instances
    df = df.with_columns(
            ((pl.col(KEY_NSOLVED) == 1) & (pl.col(KEY_SOLVED) == 1))
            .cast(pl.Int32).alias(KEY_UNIQ))

    # Shorten config names, remove leading '/' if common path exists
    if len(unique_configs) > 1:
        common_prefix = os.path.commonpath(unique_configs)
        psize = len(common_prefix) + 1
        if psize > 1:
            df = df.with_columns(
                        pl.col(KEY_CONFIG).str.slice(psize).alias(KEY_CONFIG))

    # Compute VBS and best ranks
    df = df.with_columns(
            # Compute VBS rank per benchmark over min(solved, time, memory)
            pl.struct(pl.col(KEY_SOLVED) * -1, time_key, KEY_MEMORY)
              .rank('dense')
              .over(KEY_BENCHMARK)
              .alias('vbs_rank'),
            # Compute rank of best solver min(solved, time), round to 1ms
            pl.struct(pl.col(KEY_SOLVED) * -1, pl.col(time_key).round(3))
              .rank('dense')
              .over(KEY_BENCHMARK)
              .alias('best_rank'),
          ).with_columns(
            # Compute if solver was best for a benchmark
            ((pl.col('best_rank') == 1) & (pl.col(KEY_SOLVED) > 0))
                .cast(pl.Int32).alias(KEY_BEST)
           )

    # Add VBS config
    if g_args.vbs:
        vbs_config = 'VBS'
        unique_configs.append(vbs_config)

        df_vbs = df.filter(
                    pl.col('vbs_rank') == 1
                 ).unique(KEY_BENCHMARK).with_columns(
                    pl.lit(vbs_config).alias(KEY_CONFIG)
                 )
        df = pl.concat([df, df_vbs], how='vertical')

        if not g_args.slowdown:
            g_args.slowdown = vbs_config

    # Compute slowdown column
    if g_args.slowdown:
        df_base = df.filter(
                    (pl.col(KEY_CONFIG) == g_args.slowdown)
                  ).select(pl.col(KEY_BENCHMARK), pl.col(time_key))
        df_base = df_base.rename({time_key: 'slowdown_time_base'})

        df = df.join(df_base, on=KEY_BENCHMARK).with_columns(
                (pl.col(time_key) / pl.col('slowdown_time_base'))
                .alias(KEY_TIME_SLOWDOWN)
             )
    else:
        df = df.with_columns(pl.lit(1.0).alias(KEY_TIME_SLOWDOWN))

    # Compute unsolved column
    df = df.with_columns(
            (pl.col(KEY_SOLVED) == 0).cast(pl.Int32).alias(KEY_UNSOLVED))

    return df


def group_results(df):
    global g_args

    if g_args.grouped is None:
        return df

    # Options -g, -G, -t

    prefix_len = get_common_path_prefix_len(df)

    # Group by directory for totals
    groupby_cols = [pl.col(KEY_BENCHMARK), pl.col(KEY_CONFIG)]
    if g_args.grouped is not None:
        if g_args.grouped == 0:
            # Group by configuration
            groupby_cols = [pl.col(KEY_CONFIG)]
        else:
            # Group by top/bottom-k subdirectories
            df = df.with_columns(
                    pl.col(KEY_BENCHMARK)
                        .str.slice(prefix_len)
                        .str.split(by='/')
                        .list.slice(0, g_args.grouped)
                        .list.join('/').alias(KEY_BENCHMARK)
                    )

    if g_args.synth:
        KEY_AGGS.append(pl.col(KEY_SYNTH).sum())

    df = df.group_by(groupby_cols).agg(KEY_AGGS)

    # Determine status for grouped results.
    # Group is status error/disagreement if at least one error/disagreement
    # has been detected. It's timeout/memout if all instances in the group
    # ran out of time/memory. Otherwise, the status is ok.
    df = df.with_columns(
        pl.when(pl.col(KEY_ERROR) > 0)
          .then(pl.lit(STATUS_ERR))
          .when(pl.col(KEY_DISAGR) > 0)
          .then(pl.lit(STATUS_DIS))
          .when(pl.col(KEY_MEMOUT) == pl.col(KEY_RESULT))
          .then(pl.lit(STATUS_MEM))
          .when(pl.col(KEY_TIMEOUT) == pl.col(KEY_RESULT))
          .then(pl.lit(STATUS_TIME))
          .otherwise(pl.lit(STATUS_OK))
          .alias(KEY_STATUS)
    )

    return df


def print_results(df):

    if df.is_empty():
        print('Dataframe is empty. Nothing to print.')
        sys.exit(0)

    # Determine default columns based on results (incremental/non-incremental)
    columns = [KEY_BENCHMARK, KEY_CONFIG]
    if not g_args.columns:
        is_incremental = not df.filter(pl.col(KEY_INCREMENTAL) > 0).is_empty()
        columns.extend([KEY_STATUS, KEY_RESULT])
        if g_args.grouped is not None:
            columns.extend([
                KEY_SOLVED, KEY_SAT, KEY_UNSAT, KEY_BEST, KEY_TIMEOUT,
                KEY_MEMOUT, KEY_ERROR, KEY_UNIQ, KEY_DISAGR
            ])
        elif is_incremental:
            columns.extend([KEY_SOLVED, KEY_SAT, KEY_UNSAT, KEY_BEST])
            columns.remove(KEY_RESULT)
        columns.extend([KEY_TIME_CPU, KEY_MEMORY])
    else:
        columns.extend(g_args.columns)

    if g_args.slowdown and KEY_TIME_SLOWDOWN not in columns:
        columns.append(KEY_TIME_SLOWDOWN)

    sort_keys = []
    sort_order = []
    if g_args.grouped == 0:
        columns.remove(KEY_BENCHMARK)
    else:
        sort_keys.append(pl.col(KEY_BENCHMARK))
        sort_order.append(False)

    if g_args.compare_real:
        time_key = KEY_TIME_REAL
    else:
        time_key = KEY_TIME_CPU

    # Sort totals by solved, time_cpu if possible
    sort_keys.extend([pl.col(KEY_SOLVED), pl.col(time_key)])
    sort_order.extend([True, False])

    # Sort results per group
    df = df.sort(sort_keys, descending=sort_order)

    # Add column-specific formatting
    sel_columns = []
    for k in columns:
        col = pl.col(k)
        if k == KEY_RESULT and g_args.grouped is None:
            col = col.map_elements(result_to_string, return_dtype=str)
        sel_columns.append(col)

    df = df.select(sel_columns)

    if g_args.grouped is not None and KEY_RESULT in df.schema:
        df = df.rename({KEY_RESULT: 'total'})

    # TODO: printing options
    # - html
    # - latex
    # - csv

    if g_args.csv:
        df.write_csv(sys.stdout, separator=',')
    else:
        # TODO: Add other options like ASCII_FULL_CONDENSED
        with pl.Config(tbl_formatting='NOTHING',
                       tbl_cols=-1,
                       tbl_rows=-1,
                       tbl_hide_column_data_types=True,
                       tbl_hide_dataframe_shape=True,
                       tbl_cell_numeric_alignment='RIGHT',
                       tbl_width_chars=512,
                       fmt_str_lengths=512,
                       float_precision=1):
            print(df)


def summarize_errors(df):

    df_error = df.filter(pl.col(KEY_ERROR) == 1)
    errors = {}
    for row in df_error.iter_rows(named=True):
        with open(row[KEY_OUTPUT_LOG]) as output_log:
            lines = output_log.readlines()
            idx = 0
            for i, line in enumerate(lines):
                if line.startswith('----------'):
                    idx = i + 1
                    break
            for i, line in enumerate(lines[idx:]):
                line = line.strip()
                if not line:
                    continue
                if line not in ('sat', 'unsat', 'unknown'):
                    idx += i
                    break
            error_msg = ''.join(lines[idx:])

            if error_msg not in errors:
                errors[error_msg] = []

            errors[error_msg].append(row[KEY_BENCHMARK])

    print('Detected Errors:')
    for i, (error_msg, errors) in enumerate(errors.items()):
        print('\nError #{}:'.format(i + 1))
        print('\n{}'.format(error_msg))
        print('Files:\n  {}'.format('\n  '.join(errors)))


def print_time_stats(what, start):
    global g_args
    if g_args.verbose:
        print('{}: {:.3f}s'.format(what, time.time() - start))


def prepare_data(args=None):
    # Parse options, set defaults
    parse_and_check_arguments(args)

    # Read data from log files or cache files
    start = time.time()
    if g_args.smt_comp_json:
        df = read_smt_comp_json(g_args.smt_comp_json)
    else:
        df = read_data()
    print_time_stats('extract', start)

    df = prefilter_results(df)
    if df.is_empty():
        return df

    # Process and compute data
    start = time.time()
    df = process_data(df)
    print_time_stats('process', start)

    df = filter_query(df)

    # Filter results based on given options
    start = time.time()
    df = filter_results(df)
    print_time_stats('filter', start)

    if not g_args.summarize_errors:
        # Group results by (benchmark, config)
        start = time.time()
        df = group_results(df)
        print_time_stats('group', start)

    return df


def main():
    global g_args

    df = prepare_data(None)
    if g_args.summarize_errors:
        summarize_errors(df)
    else:
        print_results(df)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit('Interrupted')
    except CmprException as e:
        sys.exit(str(e))
    except BrokenPipeError:
        pass
    sys.exit(0)
