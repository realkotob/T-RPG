extends StatesMachine

var HUD_node : Node

var active_actor : Actor setget set_active_actor

#### ACCESSORS ####

# Propagates the actor references to each states
func set_active_actor(actor : Actor):
	active_actor = actor

#### BUILT-IN #####

func _ready():
	yield(owner, "ready")
	
	HUD_node = owner.HUD_node
	
	# Connect the state_changed signal to the HUD
	var _err = connect("state_changed", HUD_node, "on_combat_state_changed")
	
	# Set the state to be the first one
	set_state(states_map[0])

# Triggered when the player push an action button, set the state to the corresponding value
func on_action_pressed(action_name : String):
	set_state(action_name)
