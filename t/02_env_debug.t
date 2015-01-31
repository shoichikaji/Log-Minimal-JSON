use strict;
use warnings;
use utf8;
use Test::More;
use JSON;
use Log::Minimal::JSON env_debug => "HOGE_DEBUG";
use Capture::Tiny 'capture';

subtest no_debug => sub {
    my ($out, $err) = capture {
        debugf "ほげ";
    };
    ok !$err;
};

subtest debug => sub {
    local $ENV{HOGE_DEBUG} = 1;
    my ($out, $err) = capture {
        debugf "ほげ";
    };
    ok $err;
    my $decoded = decode_json $err;
    is $decoded->{type}, "DEBUG";
    is $decoded->{message}, "ほげ";
    like $decoded->{trace}, qr/02_env_debug\.t/;
    like $decoded->{'@timestamp'},
        qr/\A \d{4}-\d{2}-\d{2} T \d{2}:\d{2}:\d{2} (?: Z | [+-]\d{2}:\d{2} ) \z/xsm;
};


done_testing;
