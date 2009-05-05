#!/usr/bin/env perl -w
use strict;
use Test::More;
use Net::Redmine;

require 't/net_redmine_test.pl';

plan tests => 1;

my $r = new_net_redmine();

### Prepare new tickets
my ($ticket) = new_tickets($r, 1);
my $id = $ticket->id;

diag "Created 1 ticket, id = $id\n";

$ticket->destroy;

my $t2 = Net::Redmine::Ticket->load(
    connection => $r->connection,
    id => $id
);

if ($t2) {
    fail "Failed to deleted the ticket"
}
else {
    pass "cannot load it once the ticket is destroyed.";
}
