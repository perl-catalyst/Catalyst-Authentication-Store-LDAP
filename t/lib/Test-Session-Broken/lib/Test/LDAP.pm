package Test::LDAP;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    Static::Simple
    
    Authentication
    Authorization::Roles
    Session
    Session::State::Cookie
    Session::Store::FastMmap
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in test_ldap_web.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,

    authentication => {
        default_realm => "ldap",

        realms => {
            ldap => {
                credential => {
                    "class" => "Password",
                    "password_field" => "password",
                    "password_type" => "self_check",
                    "password_hash_type" => "crypt",
                },

                "store" => {
                    "binddn"                => "anonymous",
                    "bindpw"                => "dontcare",
        
                    "class"                 => "LDAP",
    
                    "ldap_server"           => "ldap.test.no",
                    "ldap_server_options"   => { 
                        "timeout" => 30, 
                        "port" => "636", 
                        "scheme" => "ldaps" 
                    },
    
                    "role_basedn"           => "ou=stavanger,o=test,c=no",
                    "role_field"            => "cn",
                    "role_filter"           => "(&(objectClass=groupOfNames)(member=%s))",
                    "user_scope"            => "one",
                    "user_search_options"   => { 
                        "deref" => "always" 
                    }
                }
            }
        }
    }
);


# Start the application
__PACKAGE__->setup();


=head1 NAME

Test::LDAP - Catalyst based application

=head1 SYNOPSIS

    script/test_ldap_web_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Test::LDAP::Controller::Root>, L<Catalyst>

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
