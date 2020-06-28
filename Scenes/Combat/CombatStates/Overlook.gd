extends CombatStateBase

#### COMBAT OVERLOOK STATE ####

# Called when the current state of the state machine is set to this node
func enter_state():
	var active_actor = owner.active_actor
	var actor_height = active_actor.get_height()
	owner.HUD_node.update_height(actor_height)

# Called when the current state of the state machine is switched to another one
func exit_state():
	pass
