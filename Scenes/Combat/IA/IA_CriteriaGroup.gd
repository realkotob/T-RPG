extends StrategyCriteria
class_name IA_CriteriaGroup

export var exclusive_cirteria : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "IA_CriteriaGroup" or .is_class(value)
func get_class() -> String: return "IA_CriteriaGroup"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_strategy_incentives(actor: TRPG_Actor, map: CombatIsoMap) -> Dictionary:
	var total_criteria = 0.0
	for child in get_children():
		var criteria_ratio = child.compute_criteria_ratio(actor, map)
		
		if exclusive_cirteria && criteria_ratio == 0.0:
			total_criteria = 0.0
			break
		
		total_criteria += criteria_ratio
	
	var ratio = total_criteria / get_child_count() if total_criteria != 0.0 else 0.0
	
	return _compute_incentives(ratio)


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
