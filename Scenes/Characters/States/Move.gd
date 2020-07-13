extends StateBase

var speed = 5.0

# Handle the movement to the next point on the path,
# return true if the character is arrived
func move_to(world_pos : Vector2):
	var char_pos = owner.global_position
	var velocity = (world_pos - char_pos).normalized() * speed
	if char_pos.distance_to(world_pos) <= speed:
		owner.global_position = world_pos
	else:
		owner.global_position += velocity
	
	return world_pos == owner.global_position

