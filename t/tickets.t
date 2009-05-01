#!/usr/bin/env perl -w
use strict;
use Test::More;
use Net::Redmine;

unless ($_ = $ENV{NET_REDMINE_TEST}) {
    plan skip_all => "Need NET_REDMINE_TEST env var";
    exit;
}

my ($server, $user, $password) = split / /;

unless ($server && $user && $password) {
    plan skip_all => "No server and/or login credentials.";
    exit;
}

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
