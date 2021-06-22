extends TL_StateBase

#### TIMELINE EXTRACT STATE ####


# Give to the portraits that need to be inserted their new destination
# We can get which portraits to inseret by getting every portrait going further in the timeline
# Than its current position
func enter_state():
	for port in owner.get_portraits():
		if port.timeline_id_dest > port.get_index():
			if port.timeline_id_dest != -1:
				var dest = port.position * Vector2(0, 1)
				owner.move_portrait(port, dest, 0.28)
	
	var __ = owner.tween.connect("tween_all_completed", self, "_on_tween_all_completed")


func _on_tween_all_completed() -> void:
	states_machine.set_state("Idle")
