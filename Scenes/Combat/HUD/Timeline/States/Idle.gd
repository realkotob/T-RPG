extends StateBase

#### TIMELINE MOVE STATE ####

var actors_array : Array = []
var timeline_node : Node

# Reset the destinations values of every portrait in the timeline
# Call the method that update the order of the timeline nodes in the hierarchy
func enter_state():
	for actor_port in actors_array:
		actor_port.timeline_id_dest = -1
		actor_port.destination = Vector2.ONE
