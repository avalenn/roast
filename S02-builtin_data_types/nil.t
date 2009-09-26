use v6;
use Test;

plan 7;

# RT #63894
{
    my $calls;
    sub return_nil { $calls++; return; }

    $calls = 0;
    ok return_nil() ~~ Nil, 'return_nil() ~~ Nil';
    is return_nil().WHAT, 'Nil()', 'return_nil().WHAT says Nil';
    is return_nil.WHAT, 'Nil()', 'return_nil.WHAT says Nil';
    is $calls, 3, 'return_nil() called thrice';

    my $n = return_nil();
    ok $n ~~ Failure, 'variable holding nil ~~ Failure';
    is $n.WHAT, 'Failure()', '.WHAT on Nil variable says Failure';
}

#?rakudo todo 'RT 69270'
{
    my $x = '';
    $x ~= $_ for Nil;
    is $x, '', '$Statement for Nil; does zero iterations';
}

# vim: ft=perl6
