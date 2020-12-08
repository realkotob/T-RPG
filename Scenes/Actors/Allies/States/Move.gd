extends StateBase

var speed = 5.0

# Handle the movement to the next point on the path,
# return true if the character is arrived
func move_to(delta: float, world_pos : Vector2):
	var char_pos = owner.global_position
	var spd = owner.move_speed * delta
	var velocity = (world_pos - char_pos).normalized() * spd
	
	if char_pos.distance_to(world_pos) <= spd:
		owner.global_position = world_pos
	else:
		owner.global_position += velocity
	
	return world_pos == owner.global_position

