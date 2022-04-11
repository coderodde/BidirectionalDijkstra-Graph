package BidirectionalDijkstra::TargetVertexSelector;

use BidirectionalDijkstra::SourceVertexSelector;
use BidirectionalDijkstra::AlgorithmSelector;

sub new {
	my $class = shift;
	my $args = shift; # Contains search arguments.
	my $search_request_state = {
		graph => $args->{graph},
		source_vertex_id => $args->{source_vertex_id}
	};

	bless($search_request_state, $class);
	return $search_request_state;
}

sub to {
	my $self = shift;
	my $target_vertex_id = shift;
	$self->{target_vertex_id} = $target_vertex_id;
	return BidirectionalDijkstra::AlgorithmSelector->new($self);
}

1;