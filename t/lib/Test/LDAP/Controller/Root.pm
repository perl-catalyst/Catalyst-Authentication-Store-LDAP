package Test::LDAP::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->body("Index");
}

sub default :Path {
    my ( $self, $c ) = @_;

    $c->res->body("Not found");
    $c->res->status(404);
}

sub end {}

__PACKAGE__->meta->make_immutable;

1;
