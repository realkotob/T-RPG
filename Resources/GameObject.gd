extends Resource
class_name GameObject

func is_class(value: String): return value == "GameObject" or .is_class(value)
func get_class() -> String: return "GameObject"

export var name : String = ""
export var description : String = ""

#### VIRTUAL ####

func fetch_description_data() -> Array:
	return []


func get_description() -> String: return ""
