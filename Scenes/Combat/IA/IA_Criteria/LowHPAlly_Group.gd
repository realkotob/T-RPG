extends IA_CriteriaGroup
class_name LowHPAlly_Group

onready var low_HP = $LowHP


#### ACCESSORS ####

func is_class(value: String): return value == "LowHPAlly_Group" or .is_class(value)
func get_class() -> String: return "LowHPAlly_Group"


#### BUILT-IN ####



#### VIRTUALS ####

func compute_criteria_ratio(args : Dictionary) -> float:
	var actor = args["actor"]
	
	var biggest_ratio = -1.0
	var allies_array = actor.get_team().get_actors()
	
	for ally in allies_array:
		var ratio = low_HP.compute_criteria_ratio(args)
		
		if ratio > biggest_ratio:
			biggest_ratio = ratio
	
	return biggest_ratio


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
