extends PropertyCriteria
class_name ResemblanceCriteria

export var expected_ratio : float = 0.0
export var max_range_property : String = ""

#### ACCESSORS ####

func is_class(value: String): return value == "ResemblanceCriteria" or .is_class(value)
func get_class() -> String: return "ResemblanceCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func _compute_criteria_ratio(actor: TRPG_Actor, _map: CombatIsoMap) -> float:
	var value = actor.get(property)
	var max_value = actor.get(max_range_property)
	
	var ratio = value / max_value
	var ratio_difference = abs(expected_ratio - ratio) 
	
	return 1.0 - ratio_difference


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
