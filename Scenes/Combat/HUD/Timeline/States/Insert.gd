extends TL_StateBase

#### TIMELINE EXTRACT STATE ####

onready var combat_loop_node : Node = owner

export var extract_offset : int = 55

signal timeline_movement_finished

func _ready():
	var _err = connect("timeline_movement_finished", combat_loop_node, "on_timeline_movement_finished")

# Give to the portraits that need to be inserted their new destination
# We can get which portraits to inseret by getting every portrait going further in the timeline
# Than its current position
func enter_state():
	for port in portrait_array:
		if port.timeline_id_dest > port.get_index():
			if port.timeline_id_dest != -1:
				port.destination.x = 0


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
		emit_signal("timeline_movement_finished")
		return "Idle"
