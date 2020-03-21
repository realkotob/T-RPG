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


# Move the timeline so it matches the future_actors_order
func move_timeline(actors_array: Array, future_actors_order: Array):
	
	# Check if the two array size corresponds, print a error message and return if not
	if len(actors_array) != len(future_actors_order):
		print("ERROR: move_timeline() - The actors_array array size doesn't correspond the future_actors_order")
		return
	
	var actors_to_move_down : Array = []
	var actors_to_move_up : Array = []
	
	sort_actors_by_destination(actors_array, future_actors_order, actors_to_move_down, actors_to_move_up)
	
	# Give every portrait its new destination
	for actor in actors_array:
		actor.timeline_port_node.timeline_id_dest = future_actors_order.find(actor)
	
	# Give every state the array of portraits
	var portrait_array = timeline_node.get_children()
	var states_array = get_children()
	
	for state in states_array:
		if "portrait_array" in state:
			state.portrait_array = portrait_array
	
	# Triggers the movement of the timeline
	set_state("Extract")


# Sort every actor by destination
# Store every actor going up in the actors_to_move_up array 
# and every actors that move up in the actors_to_move_up array
func sort_actors_by_destination(actors_order: Array, future_actors_order: Array, actors_to_move_down: Array, actors_to_move_up: Array):
	for i in range(len(actors_order)):
		var new_id = future_actors_order.find(actors_order[i])
		if new_id > i:
			actors_to_move_down.append(actors_order[i])
		elif new_id < i:
			actors_to_move_up.append(actors_order[i])



# Count the number of actors before the given index 
func count_moving_actors_before_index(actors_array: Array, actors_to_move: Array, index: int):
	var count := 0
	for i in range(index):
		if actors_array[i] in actors_to_move:
			count += 1
	
	return count 
