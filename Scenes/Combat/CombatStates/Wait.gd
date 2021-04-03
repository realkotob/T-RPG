extends CombatStateBase

#### COMBAT WAIT STATE ####

func enter_state():
	EVENTS.emit_signal("disable_actions")
	owner.active_actor.set_action_modifier(1)
	emit_signal("turn_finished")
