#!/usr/bin/env perl -w
use strict;
use Test::Declare;
use Net::Redmine;

unless ($_ = $ENV{NET_REDMINE_TEST}) {
    plan skip_all => "Need NET_REDMINE_TEST env var";
    exit;
}

my ($server, $user, $password) = split / /;

unless ($server && $user && $password) {
    plan skip_all => "No password";
    exit;
}

plan tests => blocks;

describe "Testing about Net::Redmine::Ticket class" => run {
    my $redmine;

    init {
        $redmine = Net::Redmine::Connection->new(
            url => $server,
            user => $user,
            password => $password
        );
    };

    test "The newly created ticket id should looks sane" => run {
        my $ticket = Net::Redmine::Ticket->new( connection => $redmine );
        my $id = $ticket->create(
            subject => "testing Net::Redmine $$",
            description => "testing. testing. testing."
        );

        like $id, qr/^\d+$/;
    };
};
