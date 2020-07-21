extends CombatStateBase

#### COMBAT WAIT STATE ####

func enter_state():
	HUD_node.set_every_action_disabled()
	active_actor.set_action_modifier(1)
	emit_signal("turn_finished")
