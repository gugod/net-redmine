#!/usr/bin/env perl -w
use strict;
use Test::More;
use Net::Redmine;

require 't/net_redmine_test.pl';
my $r = new_net_redmine();

plan tests => 1;

TODO: {
    # XXX: this ticket is known to has status "Closed".
    my $id = 70;

    local $TODO = "Create a 'Closed' ticket first.";

    my $t = Net::Redmine::Ticket->new(connection => $r->connection);
    $t->load($id);

    is $t->status(), "Closed";
}
