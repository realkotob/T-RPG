extends StatesMachine
class_name CombatStateMachine

#### ACCESSORS ####


#### BUILT-IN #####

# Triggered when the player push an action button, set the state to the corresponding value
func on_action_pressed(action_name : String):
	set_state(action_name)
