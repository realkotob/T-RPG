extends Object
class_name SupportNeed

enum actor_need_type{
	HP,
	MP,
	RESSURECT,
	AILMENT
}

var need_type : int = 0
var urgency_ratio : float = 0.0

#### ACCESSORS ####

func is_class(value: String): return value == "SupportNeed" or .is_class(value)
func get_class() -> String: return "SupportNeed"


#### BUILT-IN ####

func _init(_need_type: int, _urgency_ratio: float) -> void:
	need_type = _need_type
	urgency_ratio = _urgency_ratio



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
