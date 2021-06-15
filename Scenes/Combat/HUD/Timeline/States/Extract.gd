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
				owner.move_portrait(port, Vector2(extract_offset, port.position.y), 0.28)
	
	var __ = owner.tween.connect("tween_all_completed", self, "_on_tween_all_completed", 
				[], CONNECT_ONESHOT)



func _on_tween_all_completed() -> void:
	states_machine.set_state("Move")
