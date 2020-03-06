extends Button

var combat_state_node : Node

export var WHITE := Color('#ffffff')
export var RED := Color('#ff0000')
export var GREY := Color('#777777')

signal action_pressed

func setup():
	var _err
	_err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("mouse_exited", self, "on_mouse_exited")
	_err = connect("pressed", self, "on_pressed")
	_err = connect("action_pressed", combat_state_node, "on_action_pressed")
	
	# Set it to grey if the button is disabled
	if is_disabled():
		set_modulate(GREY)


# Activate/Desactivate the button
func set_activate(value : bool):
	set_disabled(!value)
	if value == true:
		set_modulate(WHITE)
	else:
		set_modulate(GREY)


# Button highlight
func on_mouse_entered():
	if !is_disabled():
		set_modulate(RED)


# Reset the button to normal
func on_mouse_exited():
	if !is_disabled():
		set_modulate(WHITE)


# Notify the CombatState node which button has been pressed
func on_pressed():
	emit_signal("action_pressed", name)
