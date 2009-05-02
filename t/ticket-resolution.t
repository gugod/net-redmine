#!/usr/bin/env perl -w
use strict;
use Test::More;

require 't/net_redmine_test.pl';
my ($server, $user, $password) = net_redmine_test();

use Net::Redmine;

plan tests => 2;

my $r = Net::Redmine->new(url => $server,user => $user, password => $password);

my $id;
{
    my $t1 = $r->create(ticket => {subject => __FILE__ . " $$ @{[time]}",description => __FILE__ . "$$ @{[time]}"});

    is $t1->status(), "New", "The default state of a new ticket";

    $t1->status("Closed");
    $t1->save;

    $id = $t1->id;
    diag "The newly created ticket id = $id";
}

{
    my $t = Net::Redmine::Ticket->new(connection => $r->connection);
    $t->load($id);

    is $t->status(), "Closed";
}
