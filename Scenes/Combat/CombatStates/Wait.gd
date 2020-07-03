extends CombatStateBase

#### COMBAT WAIT STATE ####


func enter_state():
	active_actor.set_action_modifier(1)
	emit_signal("turn_finished")
