package BidirectionalDijkstra::DaryHeap;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our $MAXIMUM_INT = 1000 * 1000 * 1000;

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

# Preloaded methods go here.

sub new($$) {
	my $class = shift;
	my $degree = shift;
	my $self = {
		node_map             => {},
		node_array           => [],
		degree               => $degree,
		children_index_array => []
	};
	bless ($self, $class);
	return $self;
}

sub get_parent_index {
	my $self = shift;
	my $index = shift;
	return int(($index - 1) / $self->{degree});
}

sub sift_up {
	my $self = shift;
	my $index = shift;
	
	return if $index == 0;

	my $parent_index = $self->get_parent_index($index);
	my $target_node = $self->{node_array}->[$index];

	while (1) {
		my $parent_node = $self->{node_array}->[$parent_index];
		
		if ($parent_node->{priority} > $target_node->{priority}) {
			$self->{node_array}->[$index] = $parent_node;
			$parent_node->{node_index} = $index;
			$index = $parent_index;
			$parent_index = $self->get_parent_index($index);
		} else {
			last;
		}

		last if $index == 0;
	}

	$self->{node_array}->[$index] = $target_node;
	$target_node->{node_index} = $index;	
}

sub compute_children_indices {
	my $self = shift;
	my $index = shift;
	my $degree = $self->{degree};

	for my $i (0 .. $degree - 1) {
		$self->{children_index_array}->[$i] = 
			$degree * $index + $i + 1;

		if ($self->{children_index_array}
			 ->[$i] >= $self->size()) {

			$self->{children_index_array}->[$i] = 
				$MAXIMUM_INT;
				
			return;
		}		
	}
}

sub sift_down_root {
	my $self = shift;

	# Nothing to sift down:
	return if $self->size() == 0;

	my $target = $self->{node_array}->[0];
	my $priority = $target->{priority};
	my $min_child_priority;
	my $tentative_priority;
	my $min_child_index;
	my $i;
	my $degree = $self->{degree};
	my $index = 0;

	while (1) {
		$min_child_priority = $priority;
		$min_child_index = $MAXIMUM_INT;
		$self->compute_children_indices($index);

		for my $i (0 .. $degree - 1) {
			if ($self->{children_index_array}->[$i] == $MAXIMUM_INT) {
				last;
			}

			$tentative_priority = 
				$self->{node_array}
					 ->[$self->{children_index_array}
							 ->[$i]]
							 ->{priority};

			if ($min_child_priority > $tentative_priority) {
				$min_child_priority = $tentative_priority;
				$min_child_index = 
					$self->{children_index_array}
						 ->[$i];
			}
		}

		if ($min_child_index == $MAXIMUM_INT) {
			$self->{node_array}->[$index] = $target;
			$target->{node_index} = $index;
			return;
		}

		$self->{node_array}->[$index] = 
			$self->{node_array}
			     ->[$min_child_index];

		$self->{node_array}
			 ->[$index]
			 ->{node_index} = $index;

		$index = $min_child_index;
	}
}

sub add {
	my $self = shift;
	my $vertex = shift;
	my $priority = shift;	
	my $size = scalar @{$self->{node_array}};
	
	return if exists $self->{node_map}->{$vertex};

	my $node = {
		vertex_id  => $vertex,
		priority   => $priority,
		node_index => $size
	};

	$self->{node_array}->[$size] = $node;
	$self->{node_map}->{$vertex} = $node;
	$self->sift_up($size);
}

sub decreasePriority {
	my $self = shift;
	my $vertex = shift;
	my $priority = shift;
	my $node = $self->{node_map}->{$vertex};

	return if not exists $self->{node_map}->{$vertex};
	return if $priority >= $node->{priority};

	$node->{priority} = $priority;
	$self->sift_up($node->{node_index});
}

sub size {
	my $self = shift;
	my $size = @{$self->{node_array}};
	return $size;
}

sub extractMinimum {	
	my $self = shift;
	my $node = $self->{node_array}->[0];
	my $vertex = $node->{vertex_id};

	return undef if not exists $node->{vertex_id};
 	
	$self->{node_array}->[0] = $self->{node_array}->[$self->size() - 1];
	delete $self->{node_map}->{$node->{vertex_id}};
	pop @{$self->{node_array}};
	$self->sift_down_root();
	
	return $vertex;
}

1;
