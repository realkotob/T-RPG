extends Ally
class_name Character

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		hurt(10)
