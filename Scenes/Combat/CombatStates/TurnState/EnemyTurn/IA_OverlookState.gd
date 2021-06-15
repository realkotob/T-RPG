extends CombatStateBase
class_name IA_OverlookState

var actions_array := Array()

export var print_logs : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "IA_OverlookState" or .is_class(value)
func get_class() -> String: return "IA_OverlookState"

#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	.enter_state()
	enemy_action()


#### LOGIC ####

func enemy_action():
	var actor = owner.active_actor
	
	if actions_array.empty():
		actions_array = owner.ia.make_decision(actor, owner.map_node)
	
	var action = actions_array.pop_front()
	var action_state_name = action.method_name.capitalize()
	get_parent().set_state(action_state_name)
	
	if print_logs:
		print("%s decided to %s" % [actor.name, action.method_name])
	
	action.trigger_action()


#### INPUTS ####



#### SIGNAL RESPONSES ####
