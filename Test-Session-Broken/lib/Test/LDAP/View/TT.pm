package Test::LDAP::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    WRAPPER => "default.tt"
);

=head1 NAME

Test::LDAP::View::TT - TT View for Test::LDAP

=head1 DESCRIPTION

TT View for Test::LDAP.

=head1 SEE ALSO

L<Test::LDAP>

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
