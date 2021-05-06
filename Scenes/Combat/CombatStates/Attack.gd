extends NestedPushdownAutomata

#### COMBAT ATTACK STATE ####



#### BUILT-IN ####



#### VIRTUAL ####



#### INPUTS ####

func on_cancel_input():
	if is_current_state():
		states_machine.set_state("Overlook")


#### LOGIC ####



#### SIGNAL RESPONSES ####
