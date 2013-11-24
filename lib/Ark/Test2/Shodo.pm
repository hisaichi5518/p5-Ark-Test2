package Ark::Test2::Shodo;
use Mouse;
use Shodo;
use Carp;

extends "Ark::Test2";

has shodo => (
    is => "rw",
    default => sub { Shodo->new }
);

around ctx_request => sub {
    my $orig = shift;
    my ($self, $req) = @_;

    my ($res, $c) = $self->$orig($req);
    my $suzuri = $self->shodo->new_suzuri(sprintf "%s#%s ",
        ref($c->req->match->action->controller),
        $c->req->match->action->name,
    );

    $suzuri->req($req);
    $suzuri->res($res);
    $self->shodo->stock($suzuri->doc);

    wantarray ? ($res, $c) : $c;
};

no Mouse;

sub write {
    my ($self) = @_;
    my $file = (caller)[1];

    $file =~ s{^t/}{doc/};
    $file =~ s{\.t$}{\.md};

    $self->shodo->write($file);
}

1;
__END__

=encoding utf-8

=head1 NAME

Ark::Test2::Shodo - testing Ark app and write document.

=head1 SYNOPSIS

  use Ark::Test2::Shodo;
  use Test::More;

  my $app = Ark::Test2::Shodo->app_setup(
      app_name   => "MyApp",
      components => [qw(MyApp::Controller::Root)],
  );

  my $client = Ark::Test2::Shodo->new(app => $app);
  my ($res, $c) = $client->ctx_request("/");

  ok $res->header('X-API-Status');
  is_deeply $c->stash->{json}, {
    status => 200,
    result => {...},
  };

  $client->write;

=head1 DESCRIPTION

Ark::Test2 is ...

=head1 LICENSE

Copyright (C) hisaichi5518.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

hisaichi5518 E<lt>hisaichi5518@gmail.comE<gt>

=cut

