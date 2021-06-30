extends StrategyCriteria
class_name EnemyVisible

#### ACCESSORS ####

func is_class(value: String): return value == "EnemyVisible" or .is_class(value)
func get_class() -> String: return "EnemyVisible"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


func _compute_criteria_ratio(actor: TRPG_Actor, map: CombatIsoMap) -> float:
	return 0.0 




#### INPUTS ####



#### SIGNAL RESPONSES ####
