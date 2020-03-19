extends TL_StateBase

#### TIMELINE EXTRACT STATE ####

export var extract_offset : int = 55

# Give the portrait that need to be extracted their new destination
# We can get which portraits to extract by getting every portrait going further in the timeline
# Than its current position
func enter_state():
	for actor_port in actors_array:
		if actor_port.timeline_id_dest > actor_port.get_index():
			actor_port.destination.x = extract_offset


# Apply the movement of extraction
# When the movement is over, set the state back to idle
func update(_delta):
	var move_end := false
	
	# Move every portrait that needs to
	for actor_port in actors_array:
		if actor_port.destination != Vector2.ONE:
			actor_port.move_to(actor_port.destination)
	
	# Check if every portrait has arrived
	move_end = is_every_portrait_arrived()
	
	if move_end:
		return "Move"
