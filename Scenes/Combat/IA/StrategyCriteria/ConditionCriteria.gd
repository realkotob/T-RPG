extends StrategyCriteria
class_name ConditionCriteria

#### ACCESSORS ####

func is_class(value: String): return value == "ConditionCriteria" or .is_class(value)
func get_class() -> String: return "ConditionCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func condition(_actor: TRPG_Actor, _map: CombatIsoMap) -> bool:
	return true


func compute_criteria_ratio(actor: TRPG_Actor, map: CombatIsoMap) -> float:
	return float(condition(actor, map))


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
