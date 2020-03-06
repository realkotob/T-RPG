extends StatesMachine

var combat_loop_node : Node

func setup():
	for state in states_map:
		state.combat_loop_node = combat_loop_node
	set_state(states_map[0])


func on_action_pressed(action_name : String):
	print(action_name)
