#!/usr/bin/env perl -w
use strict;
use Test::More;

unless ($_ = $ENV{NET_REDMINE_TEST}) {
    plan skip_all => "Need NET_REDMINE_TEST env var";
    exit;
}

my ($server, $user, $password) = split / /;

unless ($server && $user && $password) {
    plan skip_all => "No server and/or login credentials.";
    exit;
}

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
        subject => "__FILE__ $$ @{[time]}",
        description => "__FILE__ @{[time]}"
    }
);
like $t1->id, qr/^[0-9]+$/s, "The ID of created tickets should be an Integer.";

my $t2 = $r->lookup(
    ticket => {
        id => $t1->id
    }
);

is $t2->id, $t1->id, "The loaded ticket should have correct ID.";

TODO: {
    local $TODO = "Implement identity mapping";

    use Scalar::Util qw(refaddr);
    is refaddr($t2), refaddr($t1), "ticket objects with the same ID should be identical.";
}
