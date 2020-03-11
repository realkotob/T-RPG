extends StatesMachine

var character_node : Node

func setup():
	for state in states_map:
		if "character_node" in state:
			state.character_node = character_node
	
	set_state("Idle")
