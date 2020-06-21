extends StatesMachine

var combat_loop_node : Node
var HUD_node : Node
var map_node : Node
var cursor_node : Node
var area_node : Node

var active_actor : Node

func _ready():
	yield(owner, "ready")
	
	combat_loop_node = owner
	map_node = owner.map_node
	cursor_node = owner.cursor_node
	HUD_node = owner.HUD_node
	area_node = owner.area_node

# Setup children references
func setup():
	for state in states_map:
		if "combat_loop_node" in state:
			state.combat_loop_node = combat_loop_node
		
		if "map_node" in state:
			state.map_node = map_node
		
		if "cursor_node" in state:
			state.cursor_node = cursor_node
		
		if "area_node" in state:
			state.area_node = area_node
		
		if "HUD_node" in state:
			state.HUD_node = HUD_node
		
		if state.has_method("setup"):
			state.setup()
	
	# Connect the state_changed signal to the HUD
	var _err = connect("state_changed", HUD_node, "on_combat_state_changed")
	
	# Set the state to be the first one
	set_state(states_map[0])


# Propagates the actor references to each states
func set_active_actor(actor : Object):
	active_actor = actor
	
	for state in states_map:
		if "active_actor" in state:
			state.active_actor = active_actor


# Triggered when the player push an action button, set the state to the corresponding value
func on_action_pressed(action_name : String):
	set_state(action_name)
