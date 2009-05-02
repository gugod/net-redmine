#!/usr/bin/env perl -w
use strict;
use Test::More;

require 't/net_redmine_test.pl';
my ($server, $user, $password) = net_redmine_test();

plan tests => 3;

note "Testing the top-level Net::Redmine object API";

use Net::Redmine;

my $r = Net::Redmine->new(
    url => $server,
    user => $user,
    password => $password
);

my $t1 = $r->create(
    ticket => {
        subject => __FILE__ . " $$ @{[time]}",
        description => __FILE__ . "$$ @{[time]}"
    }
);
like $t1->id, qr/^[0-9]+$/s, "The ID of created tickets should be an Integer.";

my $t2 = $r->lookup(
    ticket => {
        id => $t1->id
    }
);

is $t2->id, $t1->id, "The loaded ticket should have correct ID.";

use Scalar::Util qw(refaddr);
is refaddr($t2), refaddr($t1), "ticket objects with the same ID should be identical.";

