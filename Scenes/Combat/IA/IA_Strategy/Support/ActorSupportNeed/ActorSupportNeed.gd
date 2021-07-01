extends Object
class_name ActorSupportNeed

var actor : TRPG_Actor = null
var need_array : Array = []

#### ACCESSORS ####

func is_class(value: String): return value == "ActorSupportNeed" or .is_class(value)
func get_class() -> String: return "ActorSupportNeed"


#### BUILT-IN ####

func _init(_actor: TRPG_Actor, _need_array: Array) -> void:
	actor = _actor
	need_array = _need_array


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
