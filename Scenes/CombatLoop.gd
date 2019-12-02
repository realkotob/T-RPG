extends Node

var active_actor : Node
onready var actors_order : Array = get_tree().get_nodes_in_group("Allies")

# New turn procedure
func new_turn():
	actors_order = first_become_last(actors_order)
	active_actor = actors_order[0]

# Put the front actor at the back of the array
func first_become_last(array : Array) -> Array:
	array.append(array[0])
	array.pop_front()
	return array