extends TL_StateBase

#### TIMELINE EXTRACT STATE ####

var combat_loop_node : Node

export var extract_offset : int = 55

signal timeline_movement_finished

func setup():
	var _err = connect("timeline_movement_finished", combat_loop_node, "on_timeline_movement_finished")

# Give to the portraits that need to be inserted their new destination
# We can get which portraits to inseret by getting every portrait going further in the timeline
# Than its current position
func enter_state():
	for actor_port in actors_array:
		if actor_port.timeline_id_dest > actor_port.get_index():
			actor_port.destination.x = 0


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
		emit_signal("timeline_movement_finished")
		return "Idle"
