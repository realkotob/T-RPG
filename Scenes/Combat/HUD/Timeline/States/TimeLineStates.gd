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
func end_turn():
	var actors_array = timeline_node.get_children()
	var states_array = get_children()
	states_array.remove(len(states_array) - 1)
	
	# Tell the first port to go at the last position
	### TO BE CHANGED FOR A MORE DYNAMIC CODE LATER ###
	actors_array[0].timeline_id_dest = len(actors_array) - 1
	
	# Give every portraits its new destination
	### TO BE CHANGED FOR A MORE DYNAMIC CODE LATER ###
	for actor in actors_array:
		if actor != actors_array[0]:
			actor.timeline_id_dest = actor.get_index() - 1
	
	# Give every state the array of portraits
	for state in states_array:
		if "actors_array" in state:
			state.actors_array = actors_array
	
	# Triggers the movement of the timeline
	set_state("Extract")
