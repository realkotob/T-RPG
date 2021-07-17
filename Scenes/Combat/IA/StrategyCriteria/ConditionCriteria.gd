extends StrategyCriteria
class_name ConditionCriteria

#### ACCESSORS ####

func is_class(value: String): return value == "ConditionCriteria" or .is_class(value)
func get_class() -> String: return "ConditionCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func condition(_args : Dictionary) -> bool:
	return true


func compute_criteria_ratio(args: Dictionary) -> float:
	return float(condition(args))


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
