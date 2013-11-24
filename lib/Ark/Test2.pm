package Ark::Test2;
use Mouse;
use Plack::Test qw(test_psgi);
use HTTP::Request::Common;

use Ark::Test2::Role::Context;
use Ark::Test2::App;

our $VERSION = "0.01";

has app => (
    is => "ro",
    required => 1,
);

no Mouse;

sub app_setup {
    my $class = shift;
    Ark::Test2::App->setup(@_);
}

sub request {
    my ($self, $req) = @_;

    my $res;
    test_psgi
        app    => $self->app->handler,
        client => sub {
            my $cb = shift;
            $res = $cb->($req);
        },
    ;
}

sub get {
    my $self = shift;
    $self->request(GET(@_));
}

sub post {
    my $self = shift;
    $self->request(POST(@_));
}

sub ctx_request {
    my ($self, $req) = @_;

    unless (Ark::Context->meta->does_role('Ark::Test2::Role::Context')) {
        # Role! Role! Role!
        Ark::Context->meta->make_mutable;
        Ark::Test2::Role::Context->meta->apply( Ark::Context->meta );
        Ark::Context->meta->make_immutable;
    }

    my $res = $self->request($req);
    my $c   = Ark::Test2::_context();

    wantarray ? ($res, $c) : $c;
}

sub ctx_get {
    my $self = shift;
    $self->ctx_request(GET(@_));
}

sub ctx_post {
    my $self = shift;
    $self->ctx_request(POST(@_));
}

{
    my $c;
    sub _context {
        $c = $_[0] if $_[0];
        $c;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Ark::Test2 - testing Ark app.

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Ark::Test2 is ...

=head1 LICENSE

Copyright (C) hisaichi5518.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

hisaichi5518 E<lt>hisaichi5518@gmail.comE<gt>

=cut

