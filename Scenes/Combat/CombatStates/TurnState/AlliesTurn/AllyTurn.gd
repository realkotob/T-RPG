extends StateMachine
class_name PlayerTurn

#### ACCESSORS ####

func is_class(value: String): return value == "PlayerTurn" or .is_class(value)
func get_class() -> String: return "PlayerTurn"


#### BUILT-IN ####

func _ready() -> void:
	var _err = EVENTS.connect("actor_action_chosen", self, "_on_actor_action_chosen")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_actor_action_chosen(action_name: String):
	if is_current_state():
		set_state(action_name.capitalize())
