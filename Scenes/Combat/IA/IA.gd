extends Node
class_name IA

#### ACCESSORS ####

func is_class(value: String): return value == "IA" or .is_class(value)
func get_class() -> String: return "IA"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func make_decision(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actor_cell = actor.get_current_cell()
	var actor_range : int = actor.get_current_range()
	var actor_movement = actor.get_current_movements()
	var _actions_left = actor.get_current_actions()
	
	var aoe_target : AOE_Target = null
	
	var actions_array = []
	var with_moving_targets = []
	
	var without_moving_targets = find_damagables_in_range(actor, actor_range, map)
	
	if !without_moving_targets.empty():
		# Found a target without having to move
		aoe_target = determine_target(actor, without_moving_targets)
	
	else: 
		# Search for a target, targatable by moving before
		with_moving_targets = find_damagables_in_range(actor, actor_range + actor_movement, map)
		
		if !with_moving_targets.empty():
			aoe_target = determine_target(actor, with_moving_targets)
			var path_to_reach = map.pathfinding.find_path_to_reach(actor_cell, aoe_target.target_cell)
			path_to_reach.resize(actor_movement)
			
			actions_array.append(ActorActionRequest.new(actor, "move", [path_to_reach]))
			actions_array.append(ActorActionRequest.new(actor, "attack", [aoe_target]))
			return actions_array
	
	if aoe_target == null:
		actions_array.append(ActorActionRequest.new(actor, "wait"))
	else:
		actions_array.append(ActorActionRequest.new(actor, "attack", [aoe_target]))
	
	return actions_array


func find_damagables_in_range(actor: TRPG_Actor, actor_range: int, map: CombatIsoMap) -> Array:
	## Take line of sight in account ##
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
