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
	var target = determine_target(possible_targets)
	
	if target == null:
		action = ActorActionRequest.new(actor, "wait")
	else:
		action = ActorActionRequest.new(actor, "attack", [target])
	
	return action


func find_damagables_in_range(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actor_range = actor.get_current_range()
	return map.get_targetables_in_range(actor, actor_range)


func determine_target(targetables: Array) -> TRPG_DamagableObject:
	if targetables.empty():
		return null
	else:
		return targetables[Math.randi_range(0, targetables.size() - 1)]


#### INPUTS ####



#### SIGNAL RESPONSES ####
