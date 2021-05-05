extends CombatStateBase

#### COMBAT WAIT STATE ####

func enter_state():
	EVENTS.emit_signal("disable_actions")
	owner.active_actor.wait()
