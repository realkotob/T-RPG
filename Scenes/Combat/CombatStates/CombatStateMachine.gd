extends StatesMachine


#### ACCESSORS ####


#### BUILT-IN #####

func _ready():
	yield(owner, "ready")
	
	# Set the state to be the first one
	set_state(states_map[0])


# Triggered when the player push an action button, set the state to the corresponding value
func on_action_pressed(action_name : String):
	set_state(action_name)
