extends Resource
class_name AOE_AreaType

func is_class(value: String): return value == "AOE_AreaType" or .is_class(value)
func get_class() -> String: return "AOE_AreaType"

export var name : String = ""
export var icon : Texture = null
