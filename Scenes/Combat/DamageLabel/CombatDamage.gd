extends Object
class_name CombatDamage

enum DAMAGE_SCALE {
	NORMAL,
	HIGH,
	SEVERE
}

var damage : int = INF
var target : TRPG_DamagableObject = null
var critical : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "CombatDamage" or .is_class(value)
func get_class() -> String: return "CombatDamage"


#### BUILT-IN ####

func _init(_damage: int, _target: TRPG_DamagableObject, _critical: bool) -> void:
	damage = _damage
	target = _target
	critical = _critical

#### VIRTUALS ####



#### LOGIC ####

func get_damage_scale() -> int:
	var ratio = float(damage) / float(target.get_max_HP())
	var scale = DAMAGE_SCALE.NORMAL
	if ratio > 0.5:
		scale = DAMAGE_SCALE.SEVERE
	else:
		scale = DAMAGE_SCALE.HIGH
	
	return scale

#### INPUTS ####



#### SIGNAL RESPONSES ####
