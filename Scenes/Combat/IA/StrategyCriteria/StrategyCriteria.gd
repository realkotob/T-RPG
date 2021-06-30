extends Object
class_name StrategyCriteria

export var curve : Curve = null

export var incentives : Dictionary = {
	"Offensive": 0.0,
	"Defensive": 0.0,
	"Explore": 0.0,
	"Passive": 0.0,
	"RunAway": 0.0
}

#### ACCESSORS ####

func is_class(value: String): return value == "StrategyCriteria" or .is_class(value)
func get_class() -> String: return "StrategyCriteria"


#### BUILT-IN ####



#### VIRTUALS ####

func _compute_criteria_ratio(_actor: TRPG_Actor, _map: CombatIsoMap) -> float:
	return 0.0


func compute_strategy_incentives(actor: TRPG_Actor, map: CombatIsoMap) -> Dictionary:
	var ratio = _compute_criteria_ratio(actor, map)
	var output_incentives = Dictionary()
	var output_ratio = ratio if curve == null else curve.interpolate(ratio)
	
	for key in incentives.keys():
			output_incentives[key] = incentives[key] * output_ratio
	
	return output_incentives


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
