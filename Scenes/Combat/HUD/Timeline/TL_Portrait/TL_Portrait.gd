extends Position2D

export var speed : float = 5.0

onready var portrait_node = $Portrait

var destination := Vector2.ONE
var timeline_id_dest := -1

var actor : Node

func set_portrait_texture(portrait : Texture):
	portrait_node.set_texture(portrait)


# Move the node in the given direction, return true when the node is arrived to it's destination
func move_to(dest_position : Vector2):
	var velocity = (dest_position - position).normalized() * speed
	
	# If the distance between the node and the destination is lesser than its speed,
	# Set its position to be the destination
	if position.distance_to(dest_position) <= speed:
		position = dest_position
	else:
		position += velocity
	
	return dest_position == position
