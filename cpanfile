requires 'perl', '5.008001';
requires 'Log::Minimal';
requires 'JSON';
recommends 'JSON::XS';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Capture::Tiny';
};

