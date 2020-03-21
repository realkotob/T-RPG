extends TL_StateBase

#### TIMELINE MOVE STATE ####

# Give every portrait in the time line its new destination
func enter_state():
	# Get the height of a slot in the timeline
	var slot_height = portrait_array[0].get_node("Border").get_texture().get_height() + 2
	
	for port in portrait_array:
		if port.timeline_id_dest != -1:
			port.destination.y = port.timeline_id_dest * slot_height


# Apply the movement of extraction
# When the movement is over, set the state back to idle
func update(_delta):
	var move_end := false
	
	for port in portrait_array:
		port.move_to(port.destination)
	
	# Check if every portrait has arrived
	move_end = is_every_portrait_arrived()
	
	if move_end:
		return "Insert"
