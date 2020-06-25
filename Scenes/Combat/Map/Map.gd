tool
extends Node2D
class_name Map

# Count the number of layers
func count_layers() -> int:
	var counter : int = 0
	for child in get_children():
		if child is MapLayer:
			counter += 1
	return counter


# Return the next layer child of the given map, starting from the given index
func get_next_layer(index : int = 0) -> MapLayer:
	var children = get_children()
	var nb_map_children = children.size()
	if index >= nb_map_children:
		return null
	
	for i in range(index + 1, nb_map_children):
		if children[i] is MapLayer:
			return children[i]
	return null


# Return the next layer child of the given map, starting from the given index
func get_previous_layer(index : int = 0) -> MapLayer:
	var children = get_children()
	for i in range(index - 1, -1, -1):
		if children[i] is MapLayer:
			return children[i]
	return null


# Return the first layer of the given map
func get_first_layer() -> MapLayer:
	for child in get_children():
		if child is MapLayer:
			return child
	return null


# Return the last layer of the given map
# Alias for get_previous_layer(get_child_count())
func get_last_layer() -> MapLayer:
	return get_previous_layer(get_child_count())
