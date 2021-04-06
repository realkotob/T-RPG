extends Object
class_name CombatEffectCalculation

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectCalculation" or .is_class(value)
func get_class() -> String: return "CombatEffectCalculation"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


static func compute_damage(effect_obj: CombatEffectObject, _caster: TRPG_Actor, target: TRPG_DamagableObject) -> Array:
	var effect = effect_obj.effect
	var damage_array = Array()
	
	for _i in range(effect.nb_hits):
		var variance = rand_range(-effect.damage_variance, effect.damage_variance)
		var in_damage = effect.damage + (effect.damage * variance)
		
		var out_damage = in_damage - target.get_defense() if in_damage > 0 else in_damage
		damage_array.append(out_damage)
	
	return damage_array



#### INPUTS ####



#### SIGNAL RESPONSES ####
