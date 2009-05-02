#!/usr/bin/env perl -w
use strict;
use Test::More;
use Net::Redmine;

require 't/net_redmine_test.pl';
my $r = new_net_redmine();

plan tests => 4;

note "Testing about Net::Redmine::Ticket class";

my $subject = "Testing Net::Redmine $$ " . time;

note "The newly created ticket id should looks sane";

my $ticket = Net::Redmine::Ticket->new(connection => $r->connection);
my $id = $ticket->create(
    subject => $subject,
    description => "testing. testing. testing."
);
like $id, qr/^\d+$/;


note "Loading ticket content.";

my $ticket2 = Net::Redmine::Ticket->new(connection => $r->connection);
$ticket2->load($id);

is($ticket2->id, $ticket->id);
is($ticket2->subject, $ticket->subject);
is($ticket2->description, $ticket->description);
