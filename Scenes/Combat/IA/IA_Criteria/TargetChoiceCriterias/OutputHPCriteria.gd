extends IA_Criteria
class_name OutputHPRatioCriteria

#### ACCESSORS ####

func is_class(value: String): return value == "OutputHPRatioCriteria" or .is_class(value)
func get_class() -> String: return "OutputHPRatioCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_criteria_ratio(args: Dictionary) -> float:
	var output_state : ActorCombatState = args["result"].input_state
	return float(output_state.hp) / float(output_state.max_hp)


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
