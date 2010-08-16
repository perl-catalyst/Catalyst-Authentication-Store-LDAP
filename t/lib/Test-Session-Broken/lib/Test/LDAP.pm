package Test::LDAP;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    Authentication
    Session
    Session::State::Cookie
    Session::Store::FastMmap
/;

extends 'Catalyst';

our $VERSION = '0.01';

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

__PACKAGE__->setup();

1;
