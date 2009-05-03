#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Net::Redmine;

require 't/net_redmine_test.pl';
my $r = new_net_redmine();

### Prepare new tickets
my ($ticket) = new_tickets($r, 1);
my $id = $ticket->id;

diag "Created 1 ticket, id = $id\n";

$ticket->destroy;

my $t2 = Net::Redmine::Ticket->new(connection => $r->connection);
ok(!$t2->load($id), "cannot load it once the ticket is deleted.");
