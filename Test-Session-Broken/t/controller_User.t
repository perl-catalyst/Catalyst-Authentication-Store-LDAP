use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Test::LDAP' }
BEGIN { use_ok 'Test::LDAP::Controller::User' }

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
