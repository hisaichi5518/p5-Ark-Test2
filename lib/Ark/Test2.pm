package Ark::Test2;
use Mouse;
use Plack::Test qw(test_psgi);
use HTTP::Request::Common;

our $VERSION = "0.01";

has app => (
    is => "ro",
    required => 1,
);

no Mouse;

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

sub ctx_requeset {}

sub ctx_get {}

sub ctx_post {}

1;
__END__

=encoding utf-8

=head1 NAME

Ark::Test2 - It's new $module

=head1 SYNOPSIS

  use Ark::Test2;
  use Test::More;

  my $client = Ark::Test2->new(app => MyApp->new);
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

