extends TRPG_Actor
class_name Ally

func is_class(value: String): return value == "Ally" or .is_class(value)
func get_class() -> String: return "Ally"

func _ready():
	add_to_group("Allies")
