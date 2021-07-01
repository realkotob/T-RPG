extends GameObject
class_name CombatEffectObject

export var aoe : Resource = null
export var positive : bool = false
export var friendly_fire : bool = true
export var caster_fire : bool = true

export var effect : Resource = null

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectObject" or .is_class(value)
func get_class() -> String: return "CombatEffectObject"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func feed(_aoe: Resource, _positive: bool, _friendly_fire: bool, _caster_fire: bool) -> void:
	aoe = _aoe
	positive = _positive
	friendly_fire = _friendly_fire
	caster_fire = _caster_fire


func is_support_object() -> bool:
	return effect != null && effect.is_support_effect()

#### INPUTS ####



#### SIGNAL RESPONSES ####
