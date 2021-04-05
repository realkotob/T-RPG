extends GameObject
class_name CombatEffectObject

export var aoe : Resource = null
export var possitive : bool = false
export var friendly_fire : bool = true
export var caster_fire : bool = true

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectObject" or .is_class(value)
func get_class() -> String: return "CombatEffectObject"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
