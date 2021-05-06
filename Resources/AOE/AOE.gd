extends Resource
class_name AOE

func is_class(value: String): return value == "AOE" or .is_class(value)
func get_class() -> String: return "AOE"

export var area_type : Resource = null
export var area_size : int = 1

export var range_size : int = 1

#### BUILT-IN ####

func _init(new_area_type: Resource, new_area_size: int, new_range_size: int) -> void:
	area_type = new_area_type
	area_size = new_area_size
	range_size = new_range_size
