extends TRPG_ActorStateBase
class_name TRPG_ActorMoveState

var starting_cell := Vector3.INF

#### VIRTUALS ####

func enter_state():
	.enter_state()
	starting_cell = owner.get_current_cell()


func exit_state():
	EVENTS.emit_signal("actor_moved", owner, starting_cell, owner.get_current_cell())
	starting_cell = Vector3.INF


func update_state(delta: float):
	owner.move_along_path(delta)

