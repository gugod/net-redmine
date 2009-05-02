#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

unless ($_ = $ENV{NET_REDMINE_TEST}) {
    plan skip_all => "Need NET_REDMINE_TEST env var";
    exit;
}

my ($server, $user, $password) = split / /;

unless ($server && $user && $password) {
    plan skip_all => "No server and/or login credentials.";
    exit;
}

note "Testing the top-level Net::Redmine object API";

use Net::Redmine;

my $r = Net::Redmine->new(
    url => $server,
    user => $user,
    password => $password
);

my $ticket = $r->create(
    ticket => {
        subject => "__FILE__ $$ @{[time]}",
        description => "__FILE__ @{[time]}"
    }
);
like $ticket->id, qr/^\d+$/s;
