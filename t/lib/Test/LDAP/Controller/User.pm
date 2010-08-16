package Test::LDAP::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

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
        $c->res->body("No Args");
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
        $c->res->body("No results");
        $c->detach;
    }
}

sub view :Chained('user') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    $c->res->body("Results");
}

sub edit :Chained('user') :PathPart('edit') :Args(0)  {
    my ( $self, $c ) = @_;

    # Check if the loc that is specified is a wildcard, do an error if it's true
    if ($c->stash->{ou} =~ /^\*/) {
        $c->res->body("You cannot use '*' as an OU / Location when editing a user!");
        $c->res->status("500");
        $c->detach
    }
}

sub auto :Private {
    my ( $self, $c ) = @_;

    if (!$c->user_exists) {
        $c->log->debug('*** $c->controller::auto User not found, forwarding to auth');

        $c->response->redirect( $c->uri_for( $c->controller("Auth")->action_for("index") ) );

        return 0
    }

    return 1
}

__PACKAGE__->meta->make_immutable;

1;
