use strict;
use warnings;
use Test::More qw(no_plan);
use Test::LDAP::Client;

my $server = "ldap.test.no";

ok(
    my $slc = Test::LDAP::Client->new( "host" => $server ),
    'Created new ok towards ' . $server
);

ok(
    $slc->ous,
    "Getting Ous ok"
);
