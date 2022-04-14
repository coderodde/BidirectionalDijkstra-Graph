#!/usr/bin/perl

use strict;
use warnings;

use lib qw(./BidirectionalDijkstra-Graph/lib);

use BidirectionalDijkstra::Graph;
use BidirectionalDijkstra::DaryHeap;
use Time::HiRes qw(gettimeofday);

sub get_millis {
	return int(1000 * gettimeofday);
}

sub create_large_graph {
	my $start_time = get_millis();
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

	my $end_time = get_millis();

	print "Graph built in " . ($end_time - $start_time) . 
	      " seconds.\n";

	return $graph;
}

sub get_end_vertices {
	my $size = shift;
	return [1 + int(rand($size)), 1 + int(rand($size))];
}

sub main {
	my $graph = create_large_graph();
	my $end_vertices = get_end_vertices($graph->size());
	my $source_vertex = $end_vertices->[0];
	my $target_vertex = $end_vertices->[1];

	print "Source vertex: $source_vertex\n";
	print "Target vertex: $target_vertex\n";

	my $start_time = get_millis();
	my $path1 = $graph->findShortestPath()->from($source_vertex)->to($target_vertex)->slow();
	my $end_time = get_millis();

	print "Dijkstra's algorithm in " . ($ned_tiime - $start_time) . " milliseconds.\n";
	print "Shortest path:\n";

	foreach my $vertex @{$path1} {
		print "$vertex\n";
	}
}

main();
