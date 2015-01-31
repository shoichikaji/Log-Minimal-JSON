use strict;
use warnings;
use utf8;
use Test::More;
use Capture::Tiny 'capture';
use Log::Minimal::JSON;
use JSON;

subtest infof => sub {
    my ($out, $err) = capture {
        infof "ほげ";
    };
    like $err, qr/\n\z/sm;
    my $decoded = decode_json $err;
    is $decoded->{type}, "INFO";
    is $decoded->{message}, "ほげ";
    like $decoded->{trace}, qr/01_basic\.t/;
    like $decoded->{'@timestamp'},
        qr/\A \d{4}-\d{2}-\d{2} T \d{2}:\d{2}:\d{2} (?: Z | [+-]\d{2}:\d{2} ) \z/xsm;
};

subtest croakf => sub {
    eval { croakf "ほげ" };
    my $err = $@;
    like $err, qr/\n\z/sm;
    my $decoded = decode_json $err;
    is $decoded->{type}, "ERROR";
    is $decoded->{message}, "ほげ";
    like $decoded->{trace}, qr/01_basic\.t/;
    like $decoded->{'@timestamp'},
        qr/\A \d{4}-\d{2}-\d{2} T \d{2}:\d{2}:\d{2} (?: Z | [+-]\d{2}:\d{2} ) \z/xsm;
};

subtest no_debug => sub {
    my ($out, $err) = capture {
        debugf "ほげ";
    };
    ok !$err;
};

subtest debug => sub {
    local $ENV{LM_DEBUG} = 1;
    my ($out, $err) = capture {
        debugf "ほげ";
    };
    ok $err;
    my $decoded = decode_json $err;
    is $decoded->{type}, "DEBUG";
    is $decoded->{message}, "ほげ";
    like $decoded->{trace}, qr/01_basic\.t/;
    like $decoded->{'@timestamp'},
        qr/\A \d{4}-\d{2}-\d{2} T \d{2}:\d{2}:\d{2} (?: Z | [+-]\d{2}:\d{2} ) \z/xsm;
};

done_testing;
