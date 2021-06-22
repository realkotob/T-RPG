extends StateBase
class_name TL_StateBase

#### TIMELINE STATE BASE CLASS ####


# Check if every portrait has arrived its destination
func is_every_portrait_arrived() -> bool:
	var all_arrived = true
	
	for port in owner.get_portraits():
		if port.destination != Vector2.ONE && port.position != port.destination:
			all_arrived = false
	
	return all_arrived


func exit_state():
	if owner.tween.is_connected("tween_all_completed", self, "_on_tween_all_completed"):
		owner.tween.disconnect("tween_all_completed", self, "_on_tween_all_completed")


func _on_tween_all_completed() -> void:
	pass
