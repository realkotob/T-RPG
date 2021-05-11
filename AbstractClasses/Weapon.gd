extends Resource
class_name Weapon

func is_class(value: String): return value == "Weapon" or .is_class(value)
func get_class() -> String: return "Weapon"

export var attack_effect : Resource = null setget , get_attack_effect
export var aoe : Resource = null setget, get_aoe

#### ACCESSORS ####

func get_attack_effect() -> Resource: return attack_effect

func get_aoe() -> Resource: return aoe
