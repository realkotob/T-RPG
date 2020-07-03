extends Button
class_name CombatOptionButton

signal action_pressed

func _ready():
	yield(owner, "ready")
	
	var combat_state_node = owner.combat_state_node 
	
	var _err
	_err = connect("button_up", self, "on_pressed")
	_err = connect("action_pressed", combat_state_node, "on_action_pressed")


# Notify the CombatState node which button has been pressed
func on_pressed():
	emit_signal("action_pressed", name)
