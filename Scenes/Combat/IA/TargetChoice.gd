extends Node
class_name IA_TargetChoice

export var print_logs : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "IA_TargetChoice" or .is_class(value)
func get_class() -> String: return "IA_TargetChoice"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func choose_best_target(caster: TRPG_Actor, map: CombatIsoMap, target_array: Array, skill : Skill = null) -> TRPG_DamagableObject:
	
	var biggest_score = 0.0
	var best_target = null
	
	for target in target_array:
		var result = CombatEffectResult.new(caster, target, skill)
		var args = {
			"target" : target,
			"skill": skill,
			"caster": caster,
			"map": map,
			"result": result
		}
		var score = _compute_target_score(args)
		if score > biggest_score:
			biggest_score = score
			best_target = target
	
	if print_logs:
		print("the target chosen is %s with a score of %d" % [best_target.name, biggest_score])
	
	return best_target


func _compute_target_score(args_dict: Dictionary) -> float:
	var score : float = 0.0
	for criteria in get_children():
		var value = criteria.compute_strategy_incentives(args_dict).get("target")
		if value != null: 
			score += value
	return score


#### INPUTS ####



#### SIGNAL RESPONSES ####
