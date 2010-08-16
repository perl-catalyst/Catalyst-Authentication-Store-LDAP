package Test::LDAP::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Test::LDAP::Controller::Root - Root Controller for Test::LDAP

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 itndex

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;

    $c->stash->{"template"} = "error-404.tt";
    $c->res->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;
    my $errors = scalar @{$c->error};

    if ($errors && not defined $c->stash->{"error_msg"}) {
        $c->stash->{"template"} = "error-500.tt";

        $c->stash->{"message"} = join "\n", @{$c->error};
        $c->res->status(500);
        $c->clear_errors;
    }
}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
