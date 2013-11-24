use strict;
use warnings;

use Test::More;
use_ok "Ark::Test2::Shodo";
use Ark::Test2::App;

{
    package TestApp;
    use Ark;

    package TestApp::Controller::Root;
    use Ark 'Controller';

    has '+namespace' => default => '';

    sub default :Path {
        my ($self, $c) = @_;
        $c->res->body("OK");
    }
}

my $app = Ark::Test2::Shodo->setup_app(
    app_name   => "TestApp",
    components => [qw(TestApp::Controller::Root)],
);

subtest "ctx_post" => sub {
    my $client = Ark::Test2::Shodo->new(app => $app);
    $client->ctx_post("/");
    $client->ctx_post("/");
    $client->ctx_post("/");

    my (@matched) = $client->shodo->stock =~ m/### Response/g;
    is scalar(@matched), 3;
};

done_testing;
