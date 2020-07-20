extends StatesMachine

var HUD_node : CanvasLayer setget set_HUD_node
var active_actor : Actor setget set_active_actor

#### ACCESSORS ####

func set_active_actor(actor : Actor):
	active_actor = actor

func set_HUD_node(value: CanvasLayer):
	HUD_node = value


#### BUILT-IN #####

func _ready():
	yield(owner, "ready")
	
	var debug_panel = owner.get_node("DebugPanel")
	var _err = connect("state_changed", debug_panel, "_on_combat_state_changed")
	
	# Set the state to be the first one
	set_state(states_map[0])


# Triggered when the player push an action button, set the state to the corresponding value
func on_action_pressed(action_name : String):
	set_state(action_name)
