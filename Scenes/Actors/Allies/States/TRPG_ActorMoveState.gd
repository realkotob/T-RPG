extends State
class_name TRPG_ActorMoveState

#### VIRTUALS ####

func update_state(delta: float):
	if owner.move_along_path(delta):
		return "Idle"

