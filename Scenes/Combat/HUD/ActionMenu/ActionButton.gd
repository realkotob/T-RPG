extends Button

var combat_state_node : Node

signal action_pressed

func setup():
	var _err
	_err = connect("button_up", self, "on_pressed")
	_err = connect("action_pressed", combat_state_node, "on_action_pressed")


# Notify the CombatState node which button has been pressed
func on_pressed():
	emit_signal("action_pressed", name)
