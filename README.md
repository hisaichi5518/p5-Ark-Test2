# NAME

Ark::Test2 - testing Ark app.

# SYNOPSIS

    use Ark::Test2;
    use Test::More;

    my $app = Ark::Test2->app_setup(
        app_name   => "MyApp",
        components => [qw(MyApp::Controller::Root)],
    );

    my $client = Ark::Test2->new(app => $app);
    my ($res, $c) = $client->get("/");

    ok $res->header('X-API-Status');
    is_deeply $c->stash->{json}, {
      status => 200,
      result => {...},
    };

# DESCRIPTION

Ark::Test2 is ...

# LICENSE

Copyright (C) hisaichi5518.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

hisaichi5518 <hisaichi5518@gmail.com>
