extends StateBase
class_name TL_StateBase

#### TIMELINE STATE BASE CLASS ####

onready var timeline_node : Timeline = owner
var portrait_array : Array = []

# When the extraction is finished, empty the array
func exit_state():
	portrait_array = []


# Check if every portrait has arrived its destination
func is_every_portrait_arrived() -> bool:
	var all_arrived = true
	
	for port in portrait_array:
		if port.destination != Vector2.ONE && port.position != port.destination:
			all_arrived = false
	
	return all_arrived
