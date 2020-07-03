extends CombatOptionButton

var active_actor: Actor = null setget set_active_actor

func set_active_actor(value : Actor):
	active_actor = value

func new_turn():
	update_active()

func on_new_action():
	update_active()


func update_active():
	var current_actions = active_actor.get_current_actions()
	var max_actions = active_actor.get_max_actions()
	
	var active : bool = current_actions >= max_actions
	set_disabled(!active)
