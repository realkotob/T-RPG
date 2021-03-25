extends Resource
class_name AOE

func is_class(value: String): return value == "AOE" or .is_class(value)
func get_class() -> String: return "AOE"

export var area_type : Resource = null
export var area_size : int = 1

export var range_size : int = 1
