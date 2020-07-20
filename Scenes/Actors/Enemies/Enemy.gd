extends Actor
class_name Enemy

signal wait

func _ready():
	add_to_group("Enemies")
	var _err = connect("wait", owner, "on_actor_wait")


func turn_start():
	set_current_actions(get_max_actions() + action_modifier)
	action_modifier = 0
	
	emit_signal("wait")
