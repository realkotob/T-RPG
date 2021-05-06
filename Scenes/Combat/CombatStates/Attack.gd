extends NestedPushdownAutomata

#### COMBAT ATTACK STATE ####



#### BUILT-IN ####



#### VIRTUAL ####

func enter_state() -> void:
#	var circle_aoe_type = load(AOE_AreaType.CIRCLE)
#	var attack_aoe = AOE.new(circle_aoe_type, 1, owner.active_actor.get_current_range())
#	var attack_effect_obj = CombatEffectObject.new()
#	attack_effect_obj.feed(attack_aoe, false, false, false)
#	$TargetChoice.set_combat_effect_obj(attack_effect_obj)
	pass


#### INPUTS ####

func on_cancel_input():
	if is_current_state():
		states_machine.set_state("Overlook")


#### LOGIC ####



#### SIGNAL RESPONSES ####
