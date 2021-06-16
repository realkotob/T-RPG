extends StateBase
class_name CombatStateBase

onready var combat_loop = owner

#### ACCESSORS ####


#### BUILT-IN FUCNTIONS ####

func _ready():
	yield(owner, "ready")
	combat_loop = owner
	states_machine = get_parent()


#### LOGIC ####

func enter_state():
	EVENTS.emit_signal("disable_actions")

func exit_state():
	owner.map_node.clear_area()
