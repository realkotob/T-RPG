extends StateBase

var character_node : Node

var path : PoolVector2Array
var target_point_world : Vector2
var speed = 5.0

# Move the actor, until it's arrived to the next point
func update(_delta):
	
	if len(path) > 0:
		target_point_world = path[0]
		
	var arrived_to_next_point = move_to(target_point_world)
	
	# If the actor is arrived to the next point, remove this point from the path and take the next for destination
	if arrived_to_next_point == true:
		if len(path) > 1: 
			path.remove(0)
		
		# If the path is empty, change the state to move
		else:
			return "Idle"

# Handle the movement to the next point on the path, return true if the character is arrived
func move_to(world_position):
	
	var velocity = (world_position - character_node.global_position).normalized() * speed
	if character_node.global_position.distance_to(world_position) <= speed:
		character_node.global_position = world_position
	else:
		character_node.global_position += velocity
	
	return world_position == character_node.global_position

# Set the path whenever the player choose a destination
func _on_Idle_path_chosen(chosen_path):
	path = chosen_path
