extends Object
class_name CombatEffectResult

var input_state : ActorCombatState
var output_state : ActorCombatState

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectResult" or .is_class(value)
func get_class() -> String: return "CombatEffectResult"


#### BUILT-IN ####

func _init(caster: TRPG_Actor, target: TRPG_Actor, skill: Skill) -> void:
	input_state = target.get_combat_state()
	output_state = target.get_combat_state()
	
	var effect_obj = skill.effect if skill != null else caster.get_current_attack_effect()
	var damage = CombatEffectHandler.compute_average_damage(effect_obj, target)
	
	output_state.hp = Math.clampi(output_state.hp - damage, 0, target.get_max_HP())

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
