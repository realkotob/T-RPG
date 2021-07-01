extends ConditionCriteria
class_name HasSupportObject_Criteria

#### ACCESSORS ####

func is_class(value: String): return value == "HasSupportObject_Criteria" or .is_class(value)
func get_class() -> String: return "HasSupportObject_Criteria"


#### BUILT-IN ####



#### VIRTUALS ####

# function overrride
func condition(actor: TRPG_Actor, _map: CombatIsoMap) -> bool:
	var objects_array = actor.get_skills() + actor.get_items()
	
	for obj in objects_array:
		if obj.is_support_object():
			return true
	return false

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
