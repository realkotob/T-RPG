extends StateBase
class_name MoveAnimationState

#### ACCESSORS ####

func is_class(value: String): return value == "MoveAnimationState" or .is_class(value)
func get_class() -> String: return "MoveAnimationState"


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state() -> void:
	var _err = owner.active_actor.connect("action_finished", self, 
			"_on_actor_movement_finished", [], CONNECT_ONESHOT)

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_actor_movement_finished(_action_name: String) -> void:
	EVENTS.emit_signal("action_phase_finished")
