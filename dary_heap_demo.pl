#!/usr/bin/perl

use strict;
use warnings;
use lib qw(./BidirectionalDijkstra-Graph/lib/BidirectionalDijkstra);
use DaryHeap;

my $heap = BidirectionalDijkstra::DaryHeap->new(3);

$heap->add("v1", 1.0);
$heap->add("v2", 0.5);
$heap->add("v3", 0.0);
$heap->add("v4", 0.2);

$heap->decreasePriority("v1", 0.1);

print $heap->extractMinimum() . "\n";
print $heap->extractMinimum() . "\n";
print $heap->extractMinimum() . "\n";
print $heap->extractMinimum() . "\n";

#############


$heap = BidirectionalDijkstra::DaryHeap->new(2);

$heap->add("1", 1.0);
$heap->add("2", 0.5);

print $heap->extractMinimum() . "\n";
print $heap->extractMinimum() . "\n";

$heap->add("10", 3.0);
$heap->add("11", 2.0);
$heap->add("12", 1.0);

$heap->decreasePriority("10", 0.1);
$heap->decreasePriority("11", 0.2);

print $heap->extractMinimum() . "\n";
print $heap->extractMinimum() . "\n";
print $heap->extractMinimum() . "\n";
