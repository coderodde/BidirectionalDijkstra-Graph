package BidirectionalDijkstra::AlgorithmSelector;

use BidirectionalDijkstra::SourceVertexSelector;
use BidirectionalDijkstra::TargetVertexSelector;

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

		next if exists $settled_vertices->{$current_vertex};

		$settled_vertices->{$current_vertex} = undef;

			
	}
}

sub fast {
	my $data = shift;
	my $graph = $data->{graph};
	my $source = $data->{source_vertex_id};
	my $target = $data->{target_vertex_id};

	print "Fast: ", $graph->size(), ", ", $source, " -> ", $target, "\n";
}

1;
