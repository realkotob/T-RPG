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
	owner.HUD_node.set_every_action_disabled()

func exit_state():
	owner.area_node.clear()
