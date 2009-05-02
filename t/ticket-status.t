#!/usr/bin/env perl -w
use strict;
use Test::More;

require 't/net_redmine_test.pl';
my ($server, $user, $password) = net_redmine_test();

use Net::Redmine;

plan tests => 1;

my $r = Net::Redmine->new(url => $server,user => $user, password => $password);




TODO: {
    # XXX: this ticket is known to has status "Closed".
    my $id = 70;

    local $TODO = "Create a 'Closed' ticket first.";

    my $t = Net::Redmine::Ticket->new(connection => $r->connection);
    $t->load($id);

    is $t->status(), "Closed";
}
