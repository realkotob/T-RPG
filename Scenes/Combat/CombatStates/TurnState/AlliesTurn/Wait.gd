extends CombatStateBase

#### COMBAT WAIT STATE ####

func enter_state():
	.enter_state()
	owner.active_actor.wait()
