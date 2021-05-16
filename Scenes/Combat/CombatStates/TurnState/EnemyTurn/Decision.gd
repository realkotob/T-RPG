extends CombatStateBase
class_name DecisionState

var actions_array := Array()

#### ACCESSORS ####

func is_class(value: String): return value == "DecisionState" or .is_class(value)
func get_class() -> String: return "DecisionState"

#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	.enter_state()
	enemy_action()


#### LOGIC ####

func enemy_action():
	if actions_array.empty():
		actions_array = owner.ia.make_decision(owner.active_actor, owner.map_node)
	
	var action = actions_array.pop_front()
	var action_state_name = action.method_name.capitalize()
	get_parent().set_state(action_state_name)
	action.trigger_action()


#### INPUTS ####



#### SIGNAL RESPONSES ####
