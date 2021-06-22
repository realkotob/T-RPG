extends TL_StateBase

#### TIMELINE IDLE STATE ####

signal timeline_movement_finished

func _ready():
	var _err = connect("timeline_movement_finished", owner, "on_timeline_movement_finished")


# Reset the destinations values of every portrait in the timeline
# Call the method that update_state the order of the timeline nodes in the hierarchy
func enter_state():
	for port in owner.get_portraits():
		port.timeline_id_dest = -1
	
	if states_machine.previous_state != null:
		emit_signal("timeline_movement_finished")
