extends StateBase

class_name CombatStateBase

var active_actor : Actor setget set_active_actor
var map_node : Node setget set_map_node

signal turn_finished

#### ACCESSORS ####

func set_active_actor(value : Actor):
	active_actor = value

func set_map_node(value: Node):
	map_node = value

#### BUILT-IN FUCNTIONS ####

func _ready():
	var _err = connect("turn_finished", owner, "on_active_actor_turn_finished")

func turn_finish():
	emit_signal("turn_finished")
