package BidirectionalDijkstra::SourceVertexSelector;

use BidirectionalDijkstra::TargetVertexSelector;

sub new {
	my $class = shift;
	my $args = shift; # Contains search arguments.
	my $search_request_state = {
		graph => $args->{graph},
	};

	bless($search_request_state, $class);
	return $search_request_state;
}

sub from {
	my $self = shift;
	my $source_vertex_id = shift;
	$self->{source_vertex_id} = $source_vertex_id;
	return BidirectionalDijkstra::TargetVertexSelector->new($self);
}

1;