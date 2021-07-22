extends IA_Criteria
class_name DirectTargetCriteria

#### ACCESSORS ####

func is_class(value: String): return value == "DirectTargetCriteria" or .is_class(value)
func get_class() -> String: return "DirectTargetCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_criteria_ratio(args: Dictionary) -> float:
	var target : TRPG_Actor = args["target"]
	var caster : TRPG_Actor = args["caster"]
	var map : CombatIsoMap = args["map"]
	var skill : Skill = args.get("Skill")
	
	var path = map.pathfinding.find_path(caster.get_current_cell(), target.get_current_cell())
	var caster_movements = caster.get_current_movements()
	
	var splited_path = IsoLogic.split_move_path(path, caster_movements)
	var nb_move_needed = splited_path.size()
	
	var actions_needed = nb_move_needed
	if skill != null && skill.cost_type == Skill.COST_TYPE.ACTION_POINT:
		actions_needed += skill.cost
	else:
		actions_needed += 1
	
	return float(actions_needed <= caster.get_current_actions())

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
