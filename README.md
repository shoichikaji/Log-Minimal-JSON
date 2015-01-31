# NAME

Log::Minimal::JSON - dirty patch

# SYNOPSIS

    use Log::Minimal::JSON;

    infof "this is an info message";
    # {"@timestamp":"2015-01-31T15:39:49+09:00","message":"this is an info message","trace":"ex.pl line 3","type":"INFO"}

# DESCRIPTION

Log::Minimal::JSON may be useful for fluentd or elasticsearch.

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
