extends StateBase

class_name TL_StateBase

#### TIMELINE STATE BASE CLASS ####

var timeline_node : Node
var actors_array : Array = []


# When the extraction is finished, empty the array
func exit_state():
	actors_array = []


# Check if every portrait has arrived its destination
func is_every_portrait_arrived() -> bool:
	var all_arrived = true
	
	for actor_port in actors_array:
		if actor_port.destination != Vector2.ONE && actor_port.position != actor_port.destination:
			all_arrived = false
	
	return all_arrived
