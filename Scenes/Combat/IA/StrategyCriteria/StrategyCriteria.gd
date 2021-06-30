extends Object
class_name StrategyCriteria

export var incentives : Dictionary = {
	"Offensive": null,
	"Defensive": null,
	"Explore": null,
	"Passive": null,
	"RunAway": null
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
