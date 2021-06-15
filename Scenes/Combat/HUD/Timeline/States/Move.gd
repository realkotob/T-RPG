extends TL_StateBase

#### TIMELINE MOVE STATE ####

# Give every portrait in the time line its new destination
func enter_state():
	# Get the height of a slot in the timeline
	var slot_height = portrait_array[0].get_slot_height()
	
	for port in portrait_array:
		if port.timeline_id_dest != -1:
			var dest = Vector2(port.position.x, port.timeline_id_dest * slot_height)
			owner.move_portrait(port, dest, 0.3)
	
	var __ = owner.tween.connect("tween_all_completed", self, "_on_tween_all_completed", 
				[], CONNECT_ONESHOT)



func _on_tween_all_completed() -> void:
	states_machine.set_state("Insert")
