extends CombatStateBase
class_name WaitCombatState

#### COMBAT WAIT STATE ####

func enter_state():
	.enter_state()
	owner.active_actor.wait()
	EVENTS.emit_signal("turn_finished")
