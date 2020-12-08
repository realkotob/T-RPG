extends StateBase

class_name CombatStateBase

signal turn_finished

#### ACCESSORS ####


#### BUILT-IN FUCNTIONS ####

func _ready():
	var _err = connect("turn_finished", owner, "on_active_actor_turn_finished")

# Undo option
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_parent().set_state("Overlook")


#### LOGIC ####

func enter_state():
	owner.HUD_node.set_every_action_disabled()

func exit_state():
	owner.area_node.clear()

func turn_finish():
	emit_signal("turn_finished")
