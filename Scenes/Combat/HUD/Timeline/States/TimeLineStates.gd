extends StatesMachine

var combat_loop_node : Node

onready var timeline_node = $Timeline
onready var idle_node = $Idle
onready var extract_node = $Extract
onready var move_node = $Move
onready var insert_node = $Insert

# Setup the children nodes, and set the state to Idle by default
func setup():
	for child in get_children():
		if "timeline_node" in child:
			child.timeline_node = timeline_node
		
		if "combat_loop_node" in child:
			child.combat_loop_node = combat_loop_node
		
		if child.has_method("setup"):
			child.setup()
		
	set_state("Idle")


# Set the first actor to the last postion in the timeline
func move_timeline(actors_array: Array, actors_to_move: Array, actors_id_destinations: Array):
	
	# Check if the two array size corresponds, print a error message and return if not
	if len(actors_to_move) != len(actors_id_destinations):
		print("ERROR: move_timeline() - The actors_to_move array size doesn't correspond the actors_id_destinations")
		return
	
	var portrait_array = timeline_node.get_children()
	var states_array = get_children()
	states_array.remove(len(states_array) - 1)
	
	
	# Give every portrait that move downward its new destination
	var i := 0
	for actor in actors_to_move:
		actor.timeline_port_node.timeline_id_dest = actors_id_destinations[i]
		i += 1
	
	# Give every portrait that move upward its new destination
	i = 0
	for actor in actors_array:
		if !(actor in actors_to_move):
			var slots_to_move = count_moving_actors_before_index(actors_array, actors_to_move, i)
			portrait_array[i].timeline_id_dest = portrait_array[i].get_index() - slots_to_move
		
		i += 1
	
	# Give every state the array of portraits
	for state in states_array:
		if "portrait_array" in state:
			state.portrait_array = portrait_array
	
	# Triggers the movement of the timeline
	set_state("Extract")


# Count the number of actors before the given index 
func count_moving_actors_before_index(actors_array: Array, actors_to_move: Array, index: int):
	var count := 0
	for i in range(index):
		if actors_array[i] in actors_to_move:
			count += 1
	
	return count 
