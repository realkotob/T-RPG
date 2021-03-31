extends StateBase

class_name CombatStateBase

signal turn_finished

var state_machine : StatesMachine = null
var combat_loop : CombatLoop = null


#### ACCESSORS ####


#### BUILT-IN FUCNTIONS ####

func _ready():
	var _err = connect("turn_finished", owner, "on_active_actor_turn_finished")
	
	yield(owner, "ready")
	combat_loop = owner
	state_machine = get_parent()


#### LOGIC ####

func enter_state():
	owner.HUD_node.set_every_action_disabled()

func exit_state():
	owner.area_node.clear()

func turn_finish():
	emit_signal("turn_finished")
