extends CombatStateBase

#### COMBAT WAIT STATE ####

func enter_state():
	owner.HUD_node.set_every_action_disabled()
	owner.active_actor.set_action_modifier(1)
	emit_signal("turn_finished")
