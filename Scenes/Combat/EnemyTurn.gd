extends CombatStateBase

var actions_array := Array()

#### ACCESSORS ####



#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	.enter_state()
	enemy_action()


#### LOGIC ####

func enemy_action():
	if actions_array.empty():
		actions_array = owner.ia.make_decision(owner.active_actor, owner.map_node)
	
	var action = actions_array.pop_front()
	action.trigger_action()

#### INPUTS ####



#### SIGNAL RESPONSES ####
