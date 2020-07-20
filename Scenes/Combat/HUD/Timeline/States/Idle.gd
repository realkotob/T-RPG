extends StateBase

#### TIMELINE MOVE STATE ####

var portrait_array : Array = []
var timeline_node : Node


signal timeline_movement_finished


func _ready():
	var parent = get_parent()
	
	yield(parent, "ready")
	timeline_node = parent.timeline_node
	
	var _err = connect("timeline_movement_finished", owner, "on_timeline_movement_finished")


# Reset the destinations values of every portrait in the timeline
# Call the method that update the order of the timeline nodes in the hierarchy
func enter_state():
	for port in portrait_array:
		port.timeline_id_dest = -1
		port.destination = Vector2.ONE
	
	if states_machine.previous_state != null:
		emit_signal("timeline_movement_finished")
