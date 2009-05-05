#!/usr/bin/env perl -w
use strict;
use Test::More;
use Quantum::Superpositions;
use Net::Redmine;
use Net::Redmine::Search;

require 't/net_redmine_test.pl';
my $r = new_net_redmine();

plan tests => 1;

### Prepare new tickets
my @tickets = new_tickets($r, 2);

my $search = Net::Redmine::Search->new(
    connection => $r->connection,
    type => ['ticket'],
    query => __FILE__
);

my @found = $search->results;

ok( all( map { $_->id } @tickets ) == any(map { $_-> id } @found), "All the newly created issues can be found in the search result." );

$_->destroy for @tickets;
