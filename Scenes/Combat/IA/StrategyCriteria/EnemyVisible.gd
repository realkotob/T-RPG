extends StrategyCriteria
class_name OpponentVisible

export var expect_nb_opponent : int = 0
export var nb_opponent_threshold : int = 4

#### ACCESSORS ####

func is_class(value: String): return value == "OpponentVisible" or .is_class(value)
func get_class() -> String: return "OpponentVisible"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func compute_criteria_ratio(actor: TRPG_Actor, map: CombatIsoMap) -> float:
	var nb_opponents = map.get_nearby_opponents(actor, actor.get_view_range(), true).size()
	var ratio = clamp(float(nb_opponents) / float(nb_opponent_threshold), 0.0, 1.0)
	return ratio

#### INPUTS ####



#### SIGNAL RESPONSES ####
