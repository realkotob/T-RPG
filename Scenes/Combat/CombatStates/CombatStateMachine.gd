extends StatesMachine

var combat_loop_node : Node
var HUD_node : Node

func setup():
	for state in states_map:
		state.combat_loop_node = combat_loop_node
	set_state(states_map[0])
	
	var _err = connect("state_changed", HUD_node, "on_combat_state_changed")


func on_action_pressed(action_name : String):
	print(action_name)
