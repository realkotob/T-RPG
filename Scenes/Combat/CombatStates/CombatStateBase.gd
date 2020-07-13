extends StateBase

class_name CombatStateBase

var active_actor setget set_active_actor

signal turn_finished

#### ACCESSORS ####

func set_active_actor(value : Actor):
	active_actor = value

#### BUILT-IN FUCNTIONS ####

func _ready():
	var _err = connect("turn_finished", owner, "on_active_actor_turn_finished")

func turn_finish():
	emit_signal("turn_finished")
