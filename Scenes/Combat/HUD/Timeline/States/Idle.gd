extends StateBase

#### TIMELINE MOVE STATE ####

var portrait_array : Array = []
var timeline_node : Node

# Reset the destinations values of every portrait in the timeline
# Call the method that update the order of the timeline nodes in the hierarchy
func enter_state():
	for port in portrait_array:
		port.timeline_id_dest = -1
		port.destination = Vector2.ONE
