extends ConditionCriteria
class_name TargetKillCriteria

#### ACCESSORS ####

func is_class(value: String): return value == "TargetKillCriteria" or .is_class(value)
func get_class() -> String: return "TargetKillCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func condition(args: Dictionary) -> bool:
	var effect_result = args["result"]
	return effect_result.output_state.hp == 0


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
