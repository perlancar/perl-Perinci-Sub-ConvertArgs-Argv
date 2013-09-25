#!perl

use 5.010;
use strict;
use warnings;

use Gen::Test::Rinci::FuncResult qw(gen_test_func);
use Perinci::Sub::ConvertArgs::Argv qw(convert_args_to_argv);
use Test::More 0.98;

gen_test_func(name=>'test_convert', func=>\&convert_args_to_argv);

my $meta = {
    v => 1.1,
    args => {
        s1 => {schema=>["str"], pos=>0},
        a1 => {schema=>["str"], pos=>1},
        n  => {schema=>["num"]},
        b1 => {schema=>["bool"]},
        h1 => {schema=>["hash"]},
    },
};

test_convert(
    name   => 'empty',
    args   => {args=>{}},
    result => [],
);
test_convert(
    name   => 'use_pos=0',
    args   => {meta=>$meta, args=>{s1=>'a b', a1=>["a"], n=>2, b1=>1}},
    result => ['--a1-json', '["a"]', '--b1', '-n', 2, '--s1', 'a b'],
);
test_convert(
    name => 'use_pos=1',
    args   => {meta=>$meta, args=>{s1=>'a', a1=>[], n=>2, b1=>0}, use_pos=>1},
    result => ['a', '[]', '--nob1', '-n', 2],
);

DONE_TESTING:
done_testing;
