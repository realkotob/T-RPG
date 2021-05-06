extends Object
class_name AOE_Target

var target_cell := Vector3.ZERO
var origin_cell := Vector3.ZERO

var aoe : AOE = null
var aoe_dir : int = IsoLogic.DIRECTION.BOTTOM_RIGHT

func is_class(value: String): return value == "AOE_Target" or .is_class(value)
func get_class() -> String: return "AOE_Target"

func _init(origin_c: Vector3, target_c: Vector3, new_aoe: AOE, dir: int) -> void:
	target_cell = target_c
	origin_cell = origin_c
	aoe = new_aoe
	aoe_dir = dir
