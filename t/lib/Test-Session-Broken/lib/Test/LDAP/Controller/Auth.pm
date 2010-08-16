package Test::LDAP::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->body("Login");
}

sub login :Path("login") :Args(0) {
    my ( $self, $c ) = @_;

    my $user = $c->req->params->{'username'};
    my $pass = $c->req->params->{'password'};


    if ($c->user_exists) {
        $c->response->redirect( $c->uri_for( $c->controller("Auth")->action_for("index") ) )
    }

    # Got username / pass?
    if ( defined ($user) && defined ($pass) ) {
        # Let's auth
        my $auth = $c->authenticate (
            { username => $user, password => $pass }, "ldap"
        );

        # Let's check if we are authed, if we are then we forward to the index.
        # Else we'll throw an error into message and display the login page
        if ($auth) {
            $c->response->redirect( $c->uri_for( $c->controller("Root")->action_for("index") ) );;

            # Since we got auth, let's bind with the model with a dn & pass as well.
            #$c->model('LDAP')->bind (dn => $
        } else {
            $c->res->body("Bad user/password")
        }

    } else {
        # If not throw a message c
        $c->res->body("Missing credentials");
    }
}

sub logout : Path("logout") {
    my ( $self, $c ) = @_;

    if ($c->user_exists) {
        $c->logout;
    }
    $c->response->redirect( $c->uri_for( $c->controller("Root")->action_for("index") ) )
}

__PACKAGE__->meta->make_immutable;

1;
