extends Node
class_name IA_Strategy

onready var target_choice_incentives = get_node_or_null("TargetChoice")

export var action_list := PoolStringArray() 

export var default_coef : Dictionary = {
	"wait" : 20.0,
	"attack" : 0.0,
	"move" : 30.0,
	"skill": 0.0,
	"item": 0.0
}


#### ACCESSORS ####

func is_class(value: String): return value == "IA_Strategy" or .is_class(value)
func get_class() -> String: return "IA_Strategy"


#### BUILT-IN ####



#### VIRTUALS ####

func wait(actor: TRPG_Actor, _map: CombatIsoMap) -> Array:
	return [ActorActionRequest.new(actor, "wait")]


func attack(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actions = actor.get_current_actions()
	var movements = actor.get_current_movements()
	var attack_range = actor.get_current_range()
	var total_range = (actions - 1) * movements + attack_range
	
	var targetables = map.get_targetables_in_range(actor, total_range)
	var reacheable_targets = map.get_reachable_targets(actor, total_range, targetables)
	
	var AOE_target = _choose_AOE_target(actor, reacheable_targets, map)
	
	if AOE_target == null:
		return []
	else:
		return _create_action_from_target(actor, map, AOE_target)


func move(_actor: TRPG_Actor, _map: CombatIsoMap) -> Array:
	return []


func item(_actor: TRPG_Actor, _map: CombatIsoMap) -> Array:
	return [] 


func skill(_actor: TRPG_Actor, _map: CombatIsoMap) -> Array:
	return [] 


#### LOGIC ####


func choose_best_action(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actions = _sort_actions_by_priority()
	
	var i = 0
	var best_action = []
	while(best_action == []):
		best_action = callv(actions[i], [actor, map])
		i += 1
		if i >= actions.size():
			break
	
	return best_action


func _find_biggest_coef(array: Array) -> int:
	var best_coef_id = -1
	var biggest_coef = -INF
	
	for i in range(array.size()):
		var value = array[i]
		if value > biggest_coef:
			biggest_coef = value
			best_coef_id = i

	return best_coef_id


func _sort_actions_by_priority() -> Array:
	var actions = default_coef.duplicate()
	var sorted_actions = Array()
	
	while(!actions.empty()):
		var best_action_id = _find_biggest_coef(actions.values())
		var key = actions.keys()[best_action_id]
		sorted_actions.append(key)
		
		actions.erase(key)
	
	return sorted_actions


func _create_action_from_target(actor: TRPG_Actor, map: IsoMap, aoe_target: AOE_Target) -> Array:
	var actions_array = [ActorActionRequest.new(actor, "attack", [aoe_target])]
	var actor_range = actor.get_current_range()
	var actor_cell = actor.get_current_cell()
	var target_dist = IsoLogic.iso_2D_dist(actor_cell, aoe_target.target_cell)
	
	# Move towards the target if needed
	if target_dist > actor_range:
		var path = map.find_approch_cell_path(actor, aoe_target.target_cell)
		var action = ActorActionRequest.new(actor, "move", [path])
		actions_array.push_front(action)
	
	return actions_array


func _convert_targetables_to_aoe_targets(actor: TRPG_Actor, targetables: Array) -> Array:
	var aoe_targets_array := Array()
	for target in targetables:
		aoe_targets_array.append(AOE_Target.new(actor.get_current_cell(), 
				target.get_current_cell(), 
				actor.get_attack_aoe()))
	
	return aoe_targets_array


func _choose_AOE_target(actor: TRPG_Actor, targetables: Array, map: CombatIsoMap) -> AOE_Target:
	var target = null
	
	if !targetables.empty():
		var combat_effect_obj = actor.get_current_attack_combat_effect_object()
		target = _choose_best_target(actor, targetables, combat_effect_obj, map)
	else:
		return null
	
	return AOE_Target.new(actor.get_current_cell(), target.get_current_cell(), 
		actor.get_default_attack_aoe())


func _choose_best_target(actor: TRPG_Actor, targets_array: Array, effect: CombatEffectObject, map: CombatIsoMap) -> TRPG_DamagableObject:
	if target_choice_incentives:
		return target_choice_incentives.choose_best_target(actor, map, targets_array, effect)
	
	var indirect_targets = []
	var direct_targets = _find_direct_targets(actor, targets_array, effect)
	
	for target in targets_array:
		if not target in direct_targets:
			indirect_targets.append(target)
	
	var array_to_check = direct_targets if !direct_targets.empty() else indirect_targets
	var lowest_hp_target = _find_lowest_HP_target(array_to_check)
	
	return lowest_hp_target


func _find_lowest_HP_target(target_array: Array) -> TRPG_DamagableObject:
	var lowest_HP_target = null
	var lowest_HP = INF
	
	for target in target_array:
		var hp = target.get_current_HP()
		if hp < lowest_HP:
			lowest_HP = hp
			lowest_HP_target = target
	
	return lowest_HP_target


# Returns an array containing every targets targetable this turn
func _find_direct_targets(actor: TRPG_Actor, target_array: Array, effect: CombatEffectObject) -> Array:
	var direct_targets = []
	var aoe = effect.aoe
	var actor_cell = actor.get_current_cell()
	
	#  Should be done dynamicly
	var left_actions = actor.get_current_actions() - 1
	
	var movement_range = actor.get_current_movements() * left_actions
	var effect_range = aoe.range_size + aoe.area_size
	var total_range = effect_range + movement_range
	
	for target in target_array:
		var dist = IsoLogic.iso_2D_dist(actor_cell, target.get_current_cell())
		if dist <= total_range:
			direct_targets.append(target)
	
	return direct_targets



#### INPUTS ####



#### SIGNAL RESPONSES ####
