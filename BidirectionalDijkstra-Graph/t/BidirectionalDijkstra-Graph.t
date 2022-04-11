# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl BidirectionalDijkstra-Graph.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use BidirectionalDijkstra::Graph;
use BidirectionalDijkstra::DaryHeap;

use Test::More tests => 27;
BEGIN { use_ok('BidirectionalDijkstra::Graph') };
BEGIN { use_ok('BidirectionalDijkstra::DaryHeap') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $graph = BidirectionalDijkstra::Graph->new();

$graph->addVertex(1);
$graph->addVertex(2);

ok($graph->hasVertex(1) && $graph->hasVertex(2));
ok(not $graph->hasVertex(3));

$graph->addEdge(1, 2, 3.0);

ok($graph->hasEdge(1, 2));
ok($graph->getEdgeWeight(1, 2) == 3.0);
ok(not $graph->hasEdge(2, 1));

$graph->addEdge(2, 1);

ok($graph->hasEdge(1, 2) && $graph->hasEdge(2, 1));
ok($graph->size() == 2);
$graph->removeVertex(2);
ok($graph->size() == 1);

ok(not $graph->hasEdge(1, 2) && not $graph->hasEdge(2, 1));

$graph->addVertex(2);
$graph->addVertex(3);
$graph->addEdge(2, 3, 2.0);
$graph->addEdge(1, 2, 3.0);
$graph->addEdge(2, 1, 4.0);
$graph->addEdge(1, 3, 5.0);

ok($graph->getEdgeWeight(2, 3) == 2.0);
ok($graph->getEdgeWeight(1, 2) == 3.0);
ok($graph->getEdgeWeight(2, 1) == 4.0);
ok($graph->getEdgeWeight(1, 3) == 5.0);

$graph->removeVertex(1);
ok($graph->size() == 2);
ok($graph->hasEdge(2, 3));
ok($graph->getEdgeWeight(2, 3) == 2.0);
ok(not $graph->hasEdge(3, 2));
ok(not $graph->hasEdge(1, 2));
ok(not $graph->hasEdge(2, 1));

my $heap = BidirectionalDijkstra::DaryHeap->new(2);

is($heap->size(), 0);

$heap->add("1", 1.0);
$heap->add("2", 0.5);

is($heap->extractMinimum(), "2");
is($heap->extractMinimum(), "1");

$heap->add("10", 3.0);
$heap->add("11", 2.0);
$heap->add("12", 1.0);

$heap->decreasePriority("10", 0.1);
$heap->decreasePriority("11", 0.2);

is($heap->extractMinimum(), "10");
is($heap->extractMinimum(), "11");
is($heap->extractMinimum(), "12");

# $graph->findShortestPath()->from(1)->to(2)->slow();
# $graph->findShortestPath()->from(1)->to(13)->slow();
# $graph->findShortestPath()->from(1)->to(2)->fast();


