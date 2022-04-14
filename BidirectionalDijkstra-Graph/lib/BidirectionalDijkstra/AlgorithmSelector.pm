package BidirectionalDijkstra::AlgorithmSelector;

use BidirectionalDijkstra::SourceVertexSelector;
use BidirectionalDijkstra::TargetVertexSelector;
use BidirectionalDijkstra::Graph;

sub new {
	my $class = shift;
	my $data = shift;
	bless($data, $class);
	return $data;
}

sub tracebackPathUnidirectional {
	my $parent_map = shift;
	my $target_vertex = shift;
	my @path = [];
	my $current_vertex = $target_vertex;
	
	while (defined $current_vertex) {
		push(@path, ($current_vertex));
		$current_vertex = $parent_map->{$current_vertex};
	}

	reverse @path;
	return @path;
}

sub slow {
	my $data = shift;
	my $graph = $data->{graph};
	my $source = $data->{source_vertex_id};
	my $target = $data->{target_vertex_id};

	print "Slow: ", $graph->size(), ", ", $source, " -> ", $target, "\n";

	my $search_frontier = BidirectionalDijkstra::DaryHeap->new(4);
	my $settled_vertices = {};
	my $distance_map = {};
	my $parent_map = {};

	$search_frontier->add($source, 0.0);
	$distance_map->{$source} = 0.0;
	$parent_map->{$source} = undef;

	while ($search_frontier->size() > 0) {
		my $current_vertex = $search_frontier->extractMinimum();

		if ($current_vertex eq $target) {
			return tracebackPathUnidirectional($parent_map, $current_vertex);
		}

		if (exists $settled_vertices->{$current_vertex}) {
			next;
		}

		$settled_vertices->{$current_vertex} = undef;

		foreach my $child_vertex_id (keys %{$graph->{$current_vertex}} {
			if (exists $settled_vertices->{$child_vertex_id}) {
				next;
			}

			my $tentative_distance = $distance_map->{$current_vertex} + 
						 $graph->getEdgeWeight($current_vertex, 
								       $child_vertex_id);

			my $do_update = 0;

			if (not exists $distance_map->{$child_vertex_id}) {
				$search_frontier->add($child_vertex_id, $tentative_distancee);
				$do_update = 1;
			} elsif ($distance_map->{$child_vertex_id} > $tentative_distance) {
				$search_frontier->decreasePriority($child_vertex_id, 
								   $tentative_distance);
				$do_update = 1;
			}

			if ($update) {
				$distance_map->{$child_vertex_id} = $tentative_distance;
				$parent_map->{$child_vertex_id} = $current_vertex;
			}
		}
	}

	return undef;
}

sub fast {
	my $data = shift;
	my $graph = $data->{graph};
	my $source = $data->{source_vertex_id};
	my $target = $data->{target_vertex_id};

	print "Fast: ", $graph->size(), ", ", $source, " -> ", $target, "\n";
}

1;
