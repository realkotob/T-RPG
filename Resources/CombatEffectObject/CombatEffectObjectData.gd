extends Object
class_name CombatEffect

var referenced_obj : Resource = null
var aoe : AOE = null
export var possitive : bool = false
export var friendly_fire : bool = true
export var caster_fire : bool = true

export var effect : Resource = null

#### ACCESSORS ####

func is_class(value: String): return value == "CombatObjectEffectData" or .is_class(value)
func get_class() -> String: return "CombatObjectEffectData"


#### BUILT-IN ####

func _init(_referenced_obj: Object, _aoe: AOE, _possitive: bool,
	 _friendly_fire: bool, _caster_fire: bool, _effect: Resource = null) -> void:
	
	referenced_obj = _referenced_obj
	aoe = _aoe
	possitive = _possitive
	friendly_fire = _friendly_fire
	caster_fire = _caster_fire
	effect = _effect



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
