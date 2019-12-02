extends States

onready var character = find_parent("Character")

var path : PoolVector2Array
var target_point_world : Vector2
var speed = 5.0

# Move the actor, until it's arrived to the next point
func update(_host, _delta):
	
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
	
	var velocity = (world_position - character.position).normalized() * speed
	if character.position.distance_to(world_position) <= speed:
		character.position = world_position
	else:
		character.position += velocity
	
	return world_position == character.position

func _on_Idle_path_chosen(chosen_path):
	path = chosen_path
