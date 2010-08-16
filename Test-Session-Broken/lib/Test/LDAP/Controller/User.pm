package Test::LDAP::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Test::LDAP::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('user') :CaptureArgs(0) {
    my ($self, $c) = @_;
}

sub user :Chained('base') :PathPart('') :CaptureArgs(2) {
    my $self = shift;
    my $c    = shift;

    # Do we have an id?
    my $noargs = undef;
    if ($#_ != -1) {
        foreach (@_) {
            if ($_ =~ /^$/) { $noargs = 1 }
        }
    }

    if ($noargs) {
        $c->stash->{template} = "common/noarg.tt";
        $c->detach;
    }

    my ($id, $ou) = @_;

    # Store div stuff for use in templates.
    $c->stash( 
        id => $id, 
        ou => $ou, 
        type => "User",
        resultset => { $id => $c->model('LDAP')->user("etk") }
    );

    my $noresult = undef;
    # Do we have any entries?
    if ( $ou !~ /^\*$/ ) {
        if (not defined $c->stash->{resultset}->{$id}->{$ou}) {
            $noresult = 1;
        } else {
            $c->stash->{result}->{$id}->{$ou} = $c->stash->{resultset}->{$id}->{$ou}
        }
    } else {
        if ($c->model('LDAP')->mesg->count == 0) {
            $noresult = 1;
        } else {
            $c->stash->{result} = $c->stash->{resultset};
        }
    }

    if ($noresult) {
        $c->stash->{template} = "common/noresult.tt";
        $c->detach;
    }
}

sub view :Chained('user') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = "common/results.tt"
}

sub edit :Chained('user') :PathPart('edit') :Args(0) :FormConfig {
    my ( $self, $c ) = @_;

    # Check if the loc that is specified is a wildcard, do an error if it's true
    if ($c->stash->{ou} =~ /^\*/) {
        $c->stash(
            template => "error-generic.tt",
            message => "You cannot use '*' as an OU / Location when editing a user!",
        );
        $c->res->status("500");
        $c->detach
    }

    # Get the form.
    my $form = $c->stash->{"form"};

    # Get the ldap object from the loaded objects
    my $entry = $c->stash->{result}->{ $c->stash->{id} }->{ $c->stash->{ou} };

    #  If the form is submitted and valid let's try to update the data
    if ($form->submitted_and_valid) {
        my $params = $c->req->params;

        foreach my $attr ($params) {
            $entry->replace ($attr => $params->{$attr}) if ( defined ($params->{$attr}) );
        }

        $entry->update
    }

    # Autofill the form..
    my $options = {};
    foreach my $attr ($entry->attributes) {
        my $value = $entry->get_value($attr);
        $options->{$attr} = $value;

        push @{$c->stash->{attributes}}, $attr . ":" . $value . "<br />"
    }

    $form->default_values($options);
}

=head2 auto

Check if the user is authenicated, if not we just forward to the login page.

=cut
sub auto :Private {
    my ( $self, $c ) = @_;

    if (!$c->user_exists) {
        $c->log->debug('*** $c->controller::auto User not found, forwarding to auth');

        $c->response->redirect( $c->uri_for( $c->controller("Auth")->action_for("index") ) );

        return 0
    }

    return 1
}


=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
