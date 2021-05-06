extends Resource
class_name AOE_AreaType

func is_class(value: String): return value == "AOE_AreaType" or .is_class(value)
func get_class() -> String: return "AOE_AreaType"

export var name : String = ""
export var icon : Texture = null

const CIRCLE = "res://Resources/AOE/AOE_AreaType/AOE_Type_Circle.tres"
const SQUARE = "res://Resources/AOE/AOE_AreaType/AOE_Type_Square.tres"
const LINE_FORWARD = "res://Resources/AOE/AOE_AreaType/AOE_Type_LineForward.tres"
const LINE_PERPENDICULAR = "res://Resources/AOE/AOE_AreaType/AOE_Type_LinePerpendicular.tres"
