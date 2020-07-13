extends Actor
class_name Character

func set_state(state_name):
	$States.set_state(state_name)


func move_to(world_pos: Vector2) -> bool:
	set_state("Move")
	return $States/Move.move_to(world_pos)
