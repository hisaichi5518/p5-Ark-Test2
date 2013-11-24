use strict;
use warnings;

use Test::More;
use_ok "Ark::Test2";

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

sub build_app {
    my $app = TestApp->new();
    $app->load_component($_) for qw(TestApp::Controller::Root);
    $app->setup;

    $app;
}

my $app = build_app();

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
