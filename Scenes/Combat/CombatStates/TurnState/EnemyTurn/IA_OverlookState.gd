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
	EVENTS.emit_signal("IA_overlook_begun", owner.active_actor)
	
	enemy_action()


#### LOGIC ####

func enemy_action():
	var actor = owner.active_actor
	
	if actions_array.empty():
		actions_array = owner.ia.make_decision(actor, owner.map_node)
	
	var action = actions_array.pop_front()
	var action_state_name = action.method_name.capitalize()
	
	var future_state = get_parent().get_node(action_state_name)
	var action_target = get_action_target(action)
	
	if future_state.has_method("set_aoe_target") && action_target != null:
		future_state.set_aoe_target(action_target)
	
	get_parent().set_state(action_state_name)
	
	if print_logs:
		print("%s decided to %s" % [actor.name, action.method_name])
	
	action.trigger_action()



func get_action_target(action: ActorActionRequest) -> AOE_Target:
	for arg in action.arguments:
		if arg is AOE_Target:
			return arg
	return null



#### INPUTS ####



#### SIGNAL RESPONSES ####
