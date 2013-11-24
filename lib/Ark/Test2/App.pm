package Ark::Test2::App;
use strict;
use warnings;
use FindBin;
use Path::Class;

sub setup {
    my ($class, %args) = @_;

    my $app_name   = $args{app_name};
    my $components = $args{components};

    my $app = Mouse::load_class($app_name)->new;
    $app->load_component($_) for @$components;

    # TODO: setup_minimal
    $app->setup;
    $app->config->{home} ||= dir($FindBin::Bin);

    $app;
}

1;
