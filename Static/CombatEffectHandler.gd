extends Object
class_name CombatEffectHandler

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


static func compute_damage(effect: Effect, _caster: IsoObject, target: TRPG_DamagableObject) -> Array:
	var damage_array = Array()
	
	for _i in range(effect.nb_hits):
		var variance = rand_range(-effect.damage_variance, effect.damage_variance)
		var emitted_damage = effect.damage + (effect.damage * variance)
		
		var received_damage = compute_received_damage(emitted_damage, target)
		damage_array.append(received_damage)
	
	return damage_array


static func compute_received_damage(emitted_damage: int, target: TRPG_DamagableObject) -> int:
	return emitted_damage - target.get_defense() if emitted_damage > 0 else emitted_damage


#### INPUTS ####



#### SIGNAL RESPONSES ####
