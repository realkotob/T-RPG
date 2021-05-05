extends CombatStateBase

#### ACCESSORS ####



#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	EVENTS.emit_signal("disable_actions")
	var action_request = owner.ia.make_decision(owner.active_actor, owner.map_node)
	action_request.trigger_action()


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
