#!/usr/bin/perl

use strict;
use warnings;

use lib qw(./BidirectionalDijkstra-Graph/lib);

use BidirectionalDijkstra::Graph;
use BidirectionalDijkstra::DaryHeap;
use Time::HiRes qw(gettimeofday);

sub create_large_graph {
	my $start_time = gettimeofday;
	my $graph = BidirectionalDijkstra::Graph->new();

	for my $vertex_id (1 .. 100 * 1000) {
		$graph->addVertex($vertex_id);
	}

	for my $arc (1 .. 500 * 1000) {
		my $tail_vertex_id = 1 + int(rand(100 * 1000));
		my $head_vertex_id = 1 + int(rand(100 * 1000));
		my $weight = rand();
		$graph->addEdge($tail_vertex_id,
				$head_vertex_id,
				$weight);
	}

	my $end_time = gettimeofday;

	print "Graph built in " . int(1000 * ($end_time - $start_time)) . 
	      " seconds.\n";

	return $graph;
}

create_large_graph();
