extends Node
class_name IA

var default_coef_dict = {
	"wait" : 20,
	"attack" : 0,
	"move" : 0
}

var target_coef_modifier_dict = {
	"ally": -50,
	"enemy": 30,
	"obstacle": 10
}


#### ACCESSORS ####

func is_class(value: String): return value == "IA" or .is_class(value)
func get_class() -> String: return "IA"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


# Find all possible actions, compute their coefficent and pick the one with the biggest
func make_decision(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var possible_actions = find_possible_actions(actor, map)
	var biggest_coef = -INF
	var biggest_coef_descsion_id : int = -1
	
	for i in range(possible_actions.size()):
		var coefficient = compute_decision_coefficient(possible_actions[i], map)
		if coefficient > biggest_coef:
			biggest_coef = coefficient
			biggest_coef_descsion_id = i
	
	return possible_actions[biggest_coef_descsion_id]


# Find all possible actions and returns it in an array
func find_possible_actions(actor: TRPG_Actor, map: IsoMap) -> Array:
	var actions_array := Array()
	var without_movement_targets = find_damagables_in_range(actor, actor.get_current_range(), map)
	var with_movement_targets = find_damagables_in_range(actor, actor.get_current_range() + actor.get_current_movements(), map)
	
	var targets_array = convert_targetables_to_aoe_targets(actor, without_movement_targets + with_movement_targets)
	for target in targets_array:
		var action = create_action_from_target(actor, map, target)
		actions_array.append(action)
	
	actions_array.append([ActorActionRequest.new(actor, "wait")])
	
	return actions_array


func compute_decision_coefficient(actions_array : Array, map: IsoMap) -> int:
	var total_coef : int = 0
	for action in actions_array:
		var action_method = action.get_method_name()
		if action_method in default_coef_dict.keys():
			if action_method == "attack":
				total_coef += compute_attack_coefficient(action, map)
			total_coef += default_coef_dict[action_method]
		else:
			push_warning("The given action, %s doesn't exist in the default_coef_dict" % action_method)
	
	return total_coef


func compute_attack_coefficient(attack_request: ActorActionRequest, map: IsoMap) -> int:
	var coefficient : int = 0
	var attacker : TRPG_Actor = attack_request.actor
	var attacker_team = attacker.get_team()
	var aoe_target : AOE_Target = attack_request.arguments[0]
	var targets_array = map.get_damagable_in_area(aoe_target)
	
	for target in targets_array:
		var target_type_name = "" 
		if target.is_class("TRPG_Actor"):
			target_type_name = "ally" if target.get_team() == attacker_team else "enemy"
		else:
			target_type_name = "obstacle"
		coefficient += target_coef_modifier_dict[target_type_name]
	
	return coefficient



func create_action_from_target(actor: TRPG_Actor, map: IsoMap, aoe_target: AOE_Target) -> Array:
	var actions_array = [ActorActionRequest.new(actor, "attack", [aoe_target])]
	var actor_range = actor.get_current_range()
	var actor_cell = actor.get_current_cell()
	var target_dist = IsoLogic.iso_2D_dist(actor_cell, aoe_target.target_cell)
	var actor_movement = actor.get_current_movements()
	
	if target_dist > actor_range:
		var path_to_reach = map.pathfinding.find_path_to_reach(actor_cell, aoe_target.target_cell)
		path_to_reach.resize(int(clamp(actor_movement, 0, path_to_reach.size())))

		actions_array.push_front(ActorActionRequest.new(actor, "move", [path_to_reach]))

	
	return actions_array


func convert_targetables_to_aoe_targets(actor: TRPG_Actor, targetables: Array) -> Array:
	var aoe_targets_array := Array()
	for target in targetables:
		aoe_targets_array.append(AOE_Target.new(actor.get_current_cell(), 
				target.get_current_cell(), 
				actor.get_default_attack_aoe()))
	
	return aoe_targets_array


func find_damagables_in_range(actor: TRPG_Actor, actor_range: int, map: CombatIsoMap) -> Array:
	var reachables = map.get_targetables_in_range(actor, actor_range)
	var targetables = []
	for target in reachables:
		if actor.can_see(target):
			targetables.append(target)
	
	return targetables


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
