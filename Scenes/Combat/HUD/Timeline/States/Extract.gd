extends TL_StateBase

#### TIMELINE EXTRACT STATE ####

export var extract_offset : int = 55

# Give the portrait that need to be extracted their new destination
# We can get which portraits to extract by getting every portrait going further in the timeline
# Than its current position
func enter_state():
	for port in portrait_array:
		if port.timeline_id_dest > port.get_index():
			if port.timeline_id_dest != -1:
				port.destination = Vector2(extract_offset, port.position.y)


# Apply the movement of extraction
# When the movement is over, set the state back to idle
func update(_delta):
	var move_end := false
	
	# Move every portrait that needs to
	for port in portrait_array:
		if port.destination != Vector2.ONE:
			port.move_to(port.destination)
	
	# Check if every portrait has arrived
	move_end = is_every_portrait_arrived()
	
	if move_end:
		return "Move"
