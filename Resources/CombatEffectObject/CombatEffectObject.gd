extends GameObject
class_name CombatEffectObject

export var aoe : Resource = null
export var possitive : bool = false
export var friendly_fire : bool = true
export var caster_fire : bool = true

export var effect : Resource = null

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectObject" or .is_class(value)
func get_class() -> String: return "CombatEffectObject"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func feed(new_aoe: Resource, possitive_effect: bool, affecting_allies: bool, can_affect_self: bool) -> void:
	aoe = new_aoe
	possitive = possitive_effect
	friendly_fire = affecting_allies
	can_affect_self = can_affect_self

#### INPUTS ####



#### SIGNAL RESPONSES ####
