#!/usr/bin/env perl -w
use strict;
use Test::More;
use Net::Redmine;

require 't/net_redmine_test.pl';
my ($server, $user, $password) = net_redmine_test();

plan tests => 4;

note "Testing about Net::Redmine::Ticket class";

my $redmine = Net::Redmine::Connection->new(
    url => $server,
    user => $user,
    password => $password
);

my $subject = "Testing Net::Redmine $$ " . time;

note "The newly created ticket id should looks sane";

my $ticket = Net::Redmine::Ticket->new( connection => $redmine );
my $id = $ticket->create(
    subject => $subject,
    description => "testing. testing. testing."
);
like $id, qr/^\d+$/;


note "Loading ticket content.";

my $ticket2 = Net::Redmine::Ticket->new(connection => $redmine);
$ticket2->load($id);

is($ticket2->id, $ticket->id);
is($ticket2->subject, $ticket->subject);
is($ticket2->description, $ticket->description);
