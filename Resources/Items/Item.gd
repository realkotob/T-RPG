extends Resource
class_name Item

func is_class(value: String): return value == "Item" or .is_class(value)
func get_class() -> String: return "Item"

enum USAGE_TYPE{
	ANYWHERE,
	UNUSABLE,
	IN_COMBAT,
	OUTSIDE_COMBAT
}

export var name : String = ""
export var icon : Texture = null

export var cost : int = 0
export var usability : int = USAGE_TYPE.ANYWHERE

export var description : String = ""

export var effect : Resource = null

func fetch_description_data() -> Array:
	return [
		NormalLineData.new(name, icon, cost),
		NormalLineData.new(description)
	]
