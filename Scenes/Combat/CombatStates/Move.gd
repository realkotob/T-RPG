extends CombatStateBase

#### COMBAT MOVE STATE ####

# Connect the active actor when the state is entered
func enter_state():
	connect_actor(combat_loop_node.active_actor, true)


# Connect the active actor when the state is exited
func exit_state():
	connect_actor(combat_loop_node.active_actor, false)
