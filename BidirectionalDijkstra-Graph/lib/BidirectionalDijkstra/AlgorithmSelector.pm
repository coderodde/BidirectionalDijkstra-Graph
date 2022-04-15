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
	my $path = [];
	my $current_vertex = $target_vertex;
	
	while (defined($current_vertex)) {
		push(@{$path}, $current_vertex);
		$current_vertex = $parent_map->{$current_vertex};
	}

	return [ reverse @{$path} ];
}

sub slow {
	my $data = shift;
	my $graph = $data->{graph};
	my $source = $data->{source_vertex_id};
	my $target = $data->{target_vertex_id};
	
	if (not $graph->hasVertex($source)) {
        die "The vertex '$source' does not belong to the input graph.";
    }
    
	if (not $graph->hasVertex($target)) {
        die "The vertex '$source' does not belong to the input graph.";
    }
	
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
	
		foreach my $child_vertex_id (keys %{$graph->getChildren($current_vertex)}) {
			if (exists $settled_vertices->{$child_vertex_id}) {
				next;
			}

			my $tentative_distance = $distance_map->{$current_vertex} + 
						 $graph->getEdgeWeight($current_vertex, 
								       $child_vertex_id);

			my $do_update = 0;

			if (not exists $distance_map->{$child_vertex_id}) {
				$search_frontier->add($child_vertex_id, $tentative_distance);
				$do_update = 1;
			} elsif ($distance_map->{$child_vertex_id} > $tentative_distance) {
				$search_frontier->decreasePriority($child_vertex_id, 
								                   $tentative_distance);
				$do_update = 1;
			}

			if ($do_update) {
				$distance_map->{$child_vertex_id} = $tentative_distance;
				$parent_map->{$child_vertex_id} = $current_vertex;
			}
		}
	}

	return undef;
}

sub tracebackPathBidirectional {
	my $parent_map_forward  = shift;
	my $parent_map_backward = shift;
	my $touch_vertex = shift;
	
	my $path = [];
	my $current_vertex = $touch_vertex;
	
	while (defined($current_vertex)) {
        unshift(@{path}, $current_vertex);
		$current_vertex = $parent_map_forward->{$current_vertex};
    }
    
	$current_vertex = $parent_map_backward->{$touch_vertex};
	
	while (defined($current_vertex)) {
        push(@{$path}, $current_vertex);
		$current_vertex = $parent_map_backward->{$current_vertex};
    }
    
	
	return @{$path};
}

sub fast {
	my $data = shift;
	my $graph = $data->{graph};
	my $source = $data->{source_vertex_id};
	my $target = $data->{target_vertex_id};
	
	if (not $graph->hasVertex($source)) {
        die "The vertex '$source' does not belong to the input graph.";
    }
    
	if (not $graph->hasVertex($target)) {
        die "The vertex '$source' does not belong to the input graph.";
    }
	
	if ($source eq $target) {
		# We must handle this case outside of actual logic.
		# Otherwise, a cycle containing $source may be returned,
		# which is not optimal.
		return [ $target ];
    }
    

	my $search_frontier_forward  = BidirectionalDijkstra::DaryHeap->new(4);
	my $search_frontier_backward = BidirectionalDijkstra::DaryHeap->new(4);
	
	my $settled_vertices_forward  = {};
	my $settled_vertices_backward = {};
	
	my $distance_map_forward  = {};
	my $distance_map_backward = {};
	
	my $parent_map_forward  = {};
	my $parent_map_backward = {};
	
	$search_frontier_forward ->add($source, 0.0);
	$search_frontier_backward->add($target, 0.0);
	
	$distance_map_forward ->{$source} = 0.0;
	$distance_map_backward->{$target} = 0.0;
	
	$parent_map_forward ->{$source} = undef;
	$parent_map_backward->{$target} = undef;
	
	my $best_path_length = 2 ** 41;
	my $touch_vertex = undef;
	
	while ($search_frontier_forward ->size() > 0 and
		   $search_frontier_backward->size() > 0) {
        my $temporary_path_length =
			$distance_map_forward {$search_frontier_forward ->peekMinimum()} +
			$distance_map_backward{$search_frontier_backward->peekMinimum()};
			
		if ($temporary_path_length > $best_path_length) {
            return tracebackPathBidirectional($parent_map_forward,
											  $parent_map_backward,
											  $touch_vertex);
        }
        
		my $size_of_settled_vertices_forward  = keys %{$settled_vertices_forward};
		my $size_of_settled_vertices_backward = keys %{$settled_vertices_backward}; 
		
		if ($search_frontier_forward ->size() + $size_of_settled_vertices_forward <
			$search_frontier_backward->size() + $size_of_settled_vertices_backward) {
            
			my $current_vertex = $search_frontier_forward->extractMinimum();
			$settled_vertices_forward->{$current_vertex} = undef;
			
			foreach my $child_vertex_id (keys %{$graph->getChildren($current_vertex)}) {
				if (exists $settled_vertices_forward->{$child_vertex_id}) {
					next;
				}
				
				my $tentative_score = $distance_map_forward->{$current_vertex} +
									  $graph->getEdgeWeight($current_vertex,
														    $child_vertex_id);
				my $do_update = 0;
				
				if (not exists $distance_map_forward->{$child_vertex_id}) {
					$search_frontier_forward->add($child_vertex_id, $tentative_score);
					$do_update = 1;
                } elsif ($distance_map_forward->{$child_vertex_id} > $tentative_score) {
					$search_frontier_forward->decreasePriority($child_vertex_id,
															   $tentative_score);
					$do_update = 1;
				}
				
				if ($do_update) {
                    $distance_map_forward->{$child_vertex_id} = $tentative_score;
					$parent_map_forward->{$child_vertex_id} = $current_vertex;
					
					if (exists $settled_vertices_backward->{$child_vertex_id}) {
						my $temp_path_length =
							$tentative_score +
							$distance_map_backward->{$child_vertex_id};
						
						if ($best_path_length > $temp_path_length) {
                            $best_path_length = $temp_path_length;
							$touch_vertex = $child_vertex_id;
                        }
                        
                    }
                }
			}
        } else {
			my $current_vertex = $search_frontier_backward->extractMinimum();
			$settled_vertices_backward->{$current_vertex} = undef;
			
			foreach my $parent_vertex_id (keys %{$graph->getParents($current_vertex)}) {
				if (exists $settled_vertices_backward->{$parent_vertex_id}) {
					next;
				}
				
				my $tentative_score = $distance_map_backward->{$current_vertex} +
									  $graph->getEdgeWeight($parent_vertex_id,
														    $current_vertex);
				my $do_update = 0;
				
				if (not exists $distance_map_backward->{$parent_vertex_id}) {
					$search_frontier_backward->add($parent_vertex_id, $tentative_score);
					$do_update = 1;
                } elsif ($distance_map_backward->{$parent_vertex_id} > $tentative_score) {
					$search_frontier_backward->decreasePriority($parent_vertex_id,
										    					$tentative_score);
					$do_update = 1;
				}
				
				if ($do_update) {
                    $distance_map_backward->{$parent_vertex_id} = $tentative_score;
					$parent_map_backward  ->{$parent_vertex_id} = $current_vertex;
					
					if (exists $settled_vertices_forward->{$parent_vertex_id}) {
						my $temp_path_length =
							$tentative_score +
							$distance_map_forward->{$parent_vertex_id};
						
						if ($best_path_length > $temp_path_length) {
                            $best_path_length = $temp_path_length;
							$touch_vertex = $child_vertex_id;
                        }
                    }
                }
			}
		}
        
    }
	
	return undef;
}

1;
