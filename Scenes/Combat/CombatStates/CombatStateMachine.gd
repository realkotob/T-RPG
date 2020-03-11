extends StatesMachine

var combat_loop_node : Node
var HUD_node : Node
var map_node : TileMap
var character_node : Node
var cursor_node : Node
var area_node : Node

# Setup children references
func setup():
	for state in states_map:
		if "combat_loop_node" in state:
			state.combat_loop_node = combat_loop_node
		
		if "map_node" in state:
			state.map_node = map_node
		
		if "character_node" in state:
			state.character_node = character_node
		
		if "cursor_node" in state:
			state.cursor_node = cursor_node
		
		if "area_node" in state:
			state.area_node = area_node
		
		if state.has_method("setup"):
			state.setup()
	
	# Connect the state_changed signal to the HUD
	var _err = connect("state_changed", HUD_node, "on_combat_state_changed")
	
	# Set the state to be the first one
	set_state(states_map[0])


func on_action_pressed(action_name : String):
	set_state(action_name)
