extends Node
class_name IA_Criteria

export var incentives : Dictionary = {}

#### ACCESSORS ####

func is_class(value: String): return value == "IA_Criteria" or .is_class(value)
func get_class() -> String: return "IA_Criteria"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_criteria_ratio(_args: Dictionary) -> float:
	return 0.0


func compute_strategy_incentives(args: Dictionary) -> Dictionary:
	var ratio = compute_criteria_ratio(args)
	return _compute_incentives(ratio)


func _compute_incentives(ratio: float) -> Dictionary:
	var output_incentives = Dictionary()
	
	for key in incentives.keys():
		var incentive = incentives[key]
		
		if !is_instance_valid(incentive) or incentive == null:
			output_incentives[key] = 0.0
			continue
		
		var value = incentive.value
		var curve = incentive.curve
		var output_ratio = ratio if curve == null else curve.interpolate(ratio)
		output_incentives[key] = value * output_ratio
	
	return output_incentives


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
