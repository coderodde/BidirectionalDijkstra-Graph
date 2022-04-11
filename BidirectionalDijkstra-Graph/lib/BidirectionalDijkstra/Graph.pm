package BidirectionalDijkstra::Graph;

use BidirectionalDijkstra::SourceVertexSelector;
use BidirectionalDijkstra::TargetVertexSelector;
use BidirectionalDijkstra::AlgorithmSelector;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use BidirectionalDijkstra::Graph ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '1.6';

#require XSLoader;
#XSLoader::load('BidirectionalDijkstra::Graph', $VERSION);

# Preloaded methods go here.

my $children = 0;
my $parents  = 1;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	return $self;
}

sub addVertex {
	my ($self, $vertex_id) = @_;
	$self->{$vertex_id} = [{}, {}] if not exists $self->{$vertex_id};
}

sub hasVertex {
	my ($self, $vertex_id) = @_;
	return exists $self->{$vertex_id};
}

sub removeVertex {
	my $self = shift;
	my $vertex_id = shift;

	foreach my $child (keys %{$self->{$vertex_id}->[$children]}) {
		delete $self->{$child}->[$parents]->{$vertex_id};
	}

	foreach my $parent (keys %{$self->{$vertex_id}->[$parents]}) {
		delete $self->{$parent}->[$children]->{$vertex_id};
	}

	delete $self->{$vertex_id};
}

sub size {
	my $self = shift;
	my $size = scalar(keys(%{$self}));
	return $size;
}

sub addEdge {
	my ($self, $tail_vertex_id, $head_vertex_id, $weight) = @_;
	$self->{$tail_vertex_id}[$children]{$head_vertex_id} = $weight;
	$self->{$head_vertex_id}[$parents]{$tail_vertex_id} = $weight;
}

sub hasEdge {
	my ($self, $tail_vertex_id, $head_vertex_id) = @_;
  
  	if (not exists $self->{$tail_vertex_id}) {
  		return 0;
  	}

  	if (not exists $self->{$head_vertex_id}) {
  		return 0;
  	}

  	return exists $self->{$tail_vertex_id}->[$children]->{$head_vertex_id};
}

sub getEdgeWeight {
	my ($self, $tail_vertex_id, $head_vertex_id) = @_;
  
	if (not $self->hasEdge($tail_vertex_id, $head_vertex_id)) {
		return undef;
	}

	return $self->{$tail_vertex_id}->[$children]->{$head_vertex_id};
}

sub removeEdge {
	my ($self, $tail_vertex_id, $head_vertex_id) = @_;

	if (not exists $self->{$tail_vertex_id}) {
		return;
	}

	if (not exists $self->{$head_vertex_id}) {
		return;
	}

	if (not exists $self->{$tail_vertex_id}->[$children]->{$tail_vertex_id}) {
		return;
	}

	delete $self->{$tail_vertex_id}->[$children]->{$tail_vertex_id};
	delete $self->{$head_vertex_id}->[$parents]->{$head_vertex_id};
}

sub findShortestPath {
	my $self = shift;
	my $search_arguments = {
		graph => $self
	};

	my $source_vertex_selector = 
		BidirectionalDijkstra::SourceVertexSelector
			->new($search_arguments);

	return $source_vertex_selector;
}

sub do_unidirectional_search {
	my $graph = shift;
	my $source_vertex_id = shift;
	my $target_vertex_id = shift;
	print $graph->size(), " ", $source_vertex_id, " -> ", $target_vertex_id, "\n";
	return 1;
}

1;
__END__

=head1 NAME

BidirectionalDijkstra::Graph - Perl extension for faster pathfinding in directed weighted graphs.

=head1 SYNOPSIS

  use BidirectionalDijkstra::Graph;
  my $graph = BidirectionalDijkstra::Graph->new();

  # Add vertices
  $graph->addVertex(1);
  $graph->addVertex(2);

  # Create (directed) edges with weights
  $graph->addEdge(1, 2, 1.0);
  $graph->addEdge(2, 1, 1.0); # Simulate undirected edge.
	
	# Get edge weight
	$graph->getEdgeWeight(1, 2);

	...

	# Remove vertices
	$graph->removeVertex(3);

	# Remove edges:
	$graph->removeEdge(1, 3);

=head1 DESCRIPTION

This perl extension provides two algorithms implemented in plain (ANSI) C: unnidirectional Dijkstra's algorithm and its bidirectional counterpart.
While primary algorithm is the bidirectional search, we keep the unidirectional variant in order to make sure that both the algorithms agree on paths found.

=head1 AUTHOR

Rodion Efremov, E<lt>coderodd3(at)gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

MIT License

Copyright (c) 2022 Rodion Efremov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut
