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

done_testing;
