extends IA_Criteria
class_name TargetDistanceCriteria

export var threshold_dist : int = 15

#### ACCESSORS ####

func is_class(value: String): return value == "TargetDistanceCriteria" or .is_class(value)
func get_class() -> String: return "TargetDistanceCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_criteria_ratio(args: Dictionary) -> float:
	var target = args["target"]
	var caster = args["caster"]
	
	var dist = IsoLogic.iso_2D_dist(caster.get_current_cell(), target.get_current_cell())
	dist = Math.clampi(dist, 0, threshold_dist)
	
	return 1.0 - float(dist) / float(threshold_dist)

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
