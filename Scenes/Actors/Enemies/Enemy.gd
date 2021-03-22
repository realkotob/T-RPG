extends Actor
class_name Enemy

signal wait

var inventory := Array()

func is_class(value: String): return value == "Enemy" or .is_class(value)
func get_class() -> String: return "Enemy"

func _ready():
	add_to_group("Enemies")
	var _err = connect("wait", owner, "on_actor_wait")


func turn_start():
	set_current_actions(get_max_actions() + action_modifier)
	action_modifier = 0
	
	emit_signal("wait")
