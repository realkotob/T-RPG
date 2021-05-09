extends PushdownAutomata

#### COMBAT ATTACK STATE ####


#### BUILT-IN ####

func _ready() -> void:
	var __ = $TargetChoice.connect("target_chosen", self, "_on_target_chosen")


#### VIRTUAL ####

func enter_state():
	var attack_aoe = owner.active_actor.get_attack_aoe()
	$TargetChoice.set_aoe(attack_aoe)
	.enter_state()

#### INPUTS ####

func on_cancel_input():
	if is_current_state():
		get_parent().set_state("Overlook")


#### LOGIC ####



#### SIGNAL RESPONSES ####

func _on_target_chosen(aoe_target: AOE_Target):
	set_state("Animation")
	owner.active_actor.attack(aoe_target)
