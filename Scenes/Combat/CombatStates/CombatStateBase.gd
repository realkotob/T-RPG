extends StateBase

class_name CombatStateBase

var combat_loop_node

signal validation_button

# Connect the active actor when the state is entered
func enter_state(_host):
	connect_actor(combat_loop_node.active_actor, true)


# Connect the active actor when the state is exited
func exit_state(_host):
	connect_actor(combat_loop_node.active_actor, false)


# Connect/Disconnect the given actor, based on the value of the connect argument.
# true = connect, false = disconnect
func connect_actor(actor : Node, connect : bool) -> void:
	var _err
	if connect == true:
		_err = connect("validation_button", actor.find_node("Idle"), "_on_GameLoop_validation_button")
	elif is_connected("validation_button", actor.find_node("Idle"), "_on_GameLoop_validation_button"):
		disconnect("validation_button", actor.find_node("Idle"), "_on_GameLoop_validation_button")


# On click, notify the active actor
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		emit_signal("validation_button")