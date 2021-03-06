use v6;
use Test;

plan 2;

constant $fancy-nums       = '໕໖໗۶۷៤៥１２３';
constant $fancy-nums-value = 5676745123;

constant $all-chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklm'
    ~ 'nopqrstuvwxyz.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghi'
    ~ 'jklmnopqrstuvwxyz';

constant $all-chars-result = 2527079815159757168093382078421796304289747094823514859938627964591248797616216274592478001915.000816326530612244738449589931406080722808837890625;

subtest '.parse-base() as method' => {
    plan 48;

    is-deeply 'Perl6' .parse-base(30), 20652936,    '"Perl6"  in base-30';
    is-approx 'Perl.6'.parse-base(32), 834421.1875, '"Perl.6" in base-32';

    is-deeply '1111'.parse-base($_), +":{$_}<1111>", "1111 in base-$_"
        for 2..36;

    is-approx $all-chars.parse-base(36), $all-chars-result,
        'full character set';

    is-deeply        '-FF'.parse-base(16), -255, 'can parse - sign';
    is-deeply "\x[2212]FF".parse-base(16), -255, 'can parse − sign (fancy Unicode minus)';
    is-deeply        '+FF'.parse-base(16),  255, 'can parse + sign';

    #?rakudo.jvm todo 'Invalid base-10 character'
    is-deeply $fancy-nums.parse-base(10), $fancy-nums-value,
        'can parse fancy Unicode numerals as Int';

    #?rakudo.jvm skip 'Cannot resolve caller is-approx(Failure, Rat, Str)'
    is-approx "$fancy-nums.$fancy-nums".parse-base(10),
        "$fancy-nums-value.$fancy-nums-value".Numeric,
        'can parse fancy Unicode numerals as float';

    throws-like { "Perl6".parse-base(42) },
        X::Syntax::Number::RadixOutOfRange, radix => 42,
    'too large radix throws';

    throws-like { "Perl6".parse-base(1) },
        X::Syntax::Number::RadixOutOfRange, radix => 1,
    'too small radix throws';

    throws-like { "###".parse-base(20) },
        X::Syntax::Number::InvalidCharacter, :20radix, :0pos, :str<###>,
    'invalid char at first position, base 20';

    throws-like { "-1238321".parse-base(8) },
        X::Syntax::Number::InvalidCharacter, :8radix, :4pos, :str<1238321>,
    'invalid char in middle position, base 8';

    throws-like { "124".parse-base(4) },
        X::Syntax::Number::InvalidCharacter, :4radix, :2pos, :str<124>,
    'invalid char at last position, base 4';
}

subtest 'parse-base() as sub' => {
    plan 48;

    is-deeply parse-base('Perl6',  30), 20652936,    '"Perl6"  in base-30';
    is-approx parse-base('Perl.6', 32), 834421.1875, '"Perl.6" in base-32';

    is-deeply parse-base('1111', $_), +":{$_}<1111>", "1111 in base-$_"
        for 2..36;

    is-approx parse-base($all-chars, 36), $all-chars-result,
        'full character set';

    is-deeply parse-base(       '-FF', 16), -255, 'can parse - sign';
    is-deeply parse-base("\x[2212]FF", 16), -255, 'can parse − sign (fancy Unicode minus)';
    is-deeply parse-base(       '+FF', 16),  255, 'can parse + sign';

    #?rakudo.jvm todo 'Invalid base-10 character'
    is-deeply parse-base($fancy-nums, 10), $fancy-nums-value,
        'can parse fancy Unicode numerals as Int';

    #?rakudo.jvm skip 'Cannot resolve caller is-approx(Failure, Rat, Str)'
    is-approx parse-base("$fancy-nums.$fancy-nums", 10),
        "$fancy-nums-value.$fancy-nums-value".Numeric,
        'can parse fancy Unicode numerals as float';

    throws-like { parse-base "Perl6", 42 },
        X::Syntax::Number::RadixOutOfRange, radix => 42,
    'too large radix throws';

    throws-like { parse-base "Perl6", 1 },
        X::Syntax::Number::RadixOutOfRange, radix => 1,
    'too small radix throws';

    throws-like { parse-base "###", 20 },
        X::Syntax::Number::InvalidCharacter, :20radix, :0pos, :str<###>,
    'invalid char at first position, base 20';

    throws-like { parse-base "-1238321", 8 },
        X::Syntax::Number::InvalidCharacter, :8radix, :4pos, :str<1238321>,
    'invalid char in middle position, base 8';

    throws-like { parse-base "124", 4 },
        X::Syntax::Number::InvalidCharacter, :4radix, :2pos, :str<124>,
    'invalid char at last position, base 4';
}

# vim: ft=perl6
