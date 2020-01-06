extends StatesMachine

var combat_loop_node

func setup():
	for state in states_map:
		state.combat_loop_node = combat_loop_node
	on_ready()