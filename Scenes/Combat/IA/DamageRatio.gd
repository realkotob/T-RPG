extends IA_Criteria
class_name DamageInflictedRatioCriteria

#### ACCESSORS ####

func is_class(value: String): return value == "DamageInflictedRatioCriteria" or .is_class(value)
func get_class() -> String: return "DamageInflictedRatioCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_criteria_ratio(args: Dictionary) -> float:
	var input_state = args["result"].input_state
	var output_state = args["result"].output_state
	
	var damage = input_state.hp - output_state.hp
	return float(damage) / float(output_state.max_hp) 

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
