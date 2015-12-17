#!perl

use 5.010;
use strict;
use warnings;

use Gen::Test::Rinci::FuncResult qw(gen_test_func);
use Perinci::Sub::ConvertArgs::Argv qw(convert_args_to_argv);
use Test::More 0.98;

gen_test_func(name=>'test_convert', func=>\&convert_args_to_argv);

# must be normalized
my $meta = {
    v => 1.1,
    args => {
        s1 => {schema=>["str"], pos=>0},
        s2 => {schema=>["str"], pos=>1},
        n  => {schema=>["num"]},
        b1 => {schema=>["bool"]},
        h1 => {schema=>["hash"]},
        aos => {schema=>["array", {of=>["str"]}]},
        aoi => {schema=>["array", {of=>["int"]}]},
    },
};

test_convert(
    name   => 'empty',
    args   => {args=>{}},
    result => [],
);
test_convert(
    name   => 'use_pos=0',
    args   => {meta=>$meta, args=>{s1=>'a b', s2=>["a"], n=>2, b1=>1}},
    result => ['--b1', '-n', 2, '--s1', 'a b', '--s2-json', '["a"]'],
);
test_convert(
    name => 'use_pos=1',
    args   => {meta=>$meta, args=>{s1=>'a', s2=>[], n=>2, b1=>0}, use_pos=>1},
    result => ['a', '[]', '--nob1', '-n', 2],
);
test_convert(
    name => 'array of simple (str)',
    args   => {meta=>$meta, args=>{aos=>["foo","bar"]}},
    result => ['--aos', 'foo', '--aos', 'bar'],
);
test_convert(
    name => 'array of simple (can be comma-separated)',
    args   => {meta=>$meta, args=>{aoi=>[1,2,3]}},
    result => ['--aoi', '1,2,3'],
);

DONE_TESTING:
done_testing;
