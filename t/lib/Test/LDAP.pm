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
                    "ldap_server"           => "localhost",
                    user_basedn => "ou=foobar",
                    "ldap_server_options"   => {
                        "port" => "10636",
                    },
                    "user_scope"            => "one",
                }
            }
        }
    }
);

__PACKAGE__->setup();

1;
