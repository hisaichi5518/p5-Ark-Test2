use strict;
use warnings;

use Test::More;
use_ok "Ark::Test2";
use Ark::Test2::App;

{
    package TestApp;
    use Ark;

    package TestApp::Controller::Root;
    use Ark 'Controller';

    has '+namespace' => default => '';

    sub default :Path {
        my ($self, $c) = @_;

        if ($c->req->method eq "GET") {
            $c->res->body("GET OK");
        }
        elsif ($c->req->method eq "POST") {
            $c->res->body("POST OK");
        }

        $c->stash->{fuga} = "hoge";
    }
}

my $app = Ark::Test2->setup_app(
    app_name   => "TestApp",
    components => [qw(TestApp::Controller::Root)],
);

subtest "app" => sub {
    my $client = Ark::Test2->new(app => $app);
    isa_ok $client->app, "TestApp";
};

subtest "get" => sub {
    my $client = Ark::Test2->new(app => $app);
    my $res =  $client->get("/");

    is $res->content, "GET OK";
};

subtest "post" => sub {
    my $client = Ark::Test2->new(app => $app);
    my $res =  $client->post("/");

    is $res->content, "POST OK";
};

subtest "ctx_get" => sub {
    my $client = Ark::Test2->new(app => $app);
    my ($res, $c) =  $client->ctx_get("/");

    is_deeply $c->stash, {fuga => "hoge"};
};

subtest "ctx_post" => sub {
    my $client = Ark::Test2->new(app => $app);
    my ($res, $c) =  $client->ctx_post("/");

    is_deeply $c->stash, {fuga => "hoge"};
};

subtest "ctx_post: not list context" => sub {
    my $client = Ark::Test2->new(app => $app);
    my $c = $client->ctx_post("/");

    is_deeply $c->stash, {fuga => "hoge"};
};

done_testing;
