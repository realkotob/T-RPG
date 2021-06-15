extends StateBase
class_name MoveAnimationState

#### ACCESSORS ####

func is_class(value: String): return value == "MoveAnimationState" or .is_class(value)
func get_class() -> String: return "MoveAnimationState"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("actor_moved", self, "_on_actor_moved")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_actor_moved(actor: TRPG_Actor, _from: Vector3, _to: Vector3) -> void:
	if !is_current_state() or actor != owner.active_actor:
		return
	
	EVENTS.emit_signal("action_phase_finished")
