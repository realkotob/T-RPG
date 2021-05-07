extends Node
class_name IA

#### ACCESSORS ####

func is_class(value: String): return value == "IA" or .is_class(value)
func get_class() -> String: return "IA"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func make_decision(actor: TRPG_Actor, map: CombatIsoMap) -> ActorActionRequest:
	var action = null
	var possible_targets = find_damagables_in_range(actor, map)
	var aoe_target = determine_target(actor, possible_targets)
	
	if aoe_target == null:
		action = ActorActionRequest.new(actor, "wait")
	else:
		action = ActorActionRequest.new(actor, "attack", [aoe_target])
	
	return action


func find_damagables_in_range(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actor_range = actor.get_current_range()
	return map.get_targetables_in_range(actor, actor_range)


func determine_target(actor: TRPG_Actor, targetables: Array) -> AOE_Target:
	var target = null
	
	if !targetables.empty():
		target = targetables[Math.randi_range(0, targetables.size() - 1)]
	else:
		return null
	
	return AOE_Target.new(actor.get_current_cell(), target.get_current_cell(), 
		actor.get_default_attack_aoe())


#### INPUTS ####



#### SIGNAL RESPONSES ####
