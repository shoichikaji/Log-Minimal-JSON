package Log::Minimal::JSON;
use 5.008001;
use strict;
use warnings;
use Time::Local ();
use JSON ();

our $VERSION = "0.01";

my $TZOFFSET = do {
    my @localtime = localtime;
    my $sec = Time::Local::timegm(@localtime) - Time::Local::timelocal(@localtime);
    if ($sec == 0) {
        "Z";
    } else {
        my $sign = $sec > 0 ? "+" : "-";
        $sec = abs $sec;
        my $hour = int $sec / (60*60);
        my $min  = $sec % (60*60);
        sprintf "%s%02d:%02d", $sign, $hour, $min;
    }
};

my $JSON = JSON->new->utf8(1)->canonical(1);

sub encode_json {
    my ($time, $type, $message, $trace, $raw_message) = @_;
    $JSON->encode({
        '@timestamp' => "$time$TZOFFSET",
        'type' => $type,
        'message' => $message,
        'trace' => $trace,
    });
}

require Log::Minimal;
no warnings 'once';
$Log::Minimal::PRINT = sub { warn encode_json(@_) . "\n" };
$Log::Minimal::DIE = sub { die encode_json(@_) . "\n" };
use warnings 'once';
sub import { goto &Log::Minimal::import }

1;
__END__

=encoding utf-8

=head1 NAME

Log::Minimal::JSON - dirty patch

=head1 SYNOPSIS

    use Log::Minimal::JSON;

    infof "this is an info message";
    # {"@timestamp":"2015-01-31T15:39:49+09:00","message":"this is an info message","trace":"ex.pl line 3","type":"INFO"}

=head1 DESCRIPTION

Log::Minimal::JSON may be useful for fluentd or elasticsearch.

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

