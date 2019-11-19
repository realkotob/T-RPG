extends Position2D

export(float) var SPEED = 5.0

enum STATES { IDLE, FOLLOW }
var _state = null

var path = []
var target_point_world = Vector2()
var target_position = Vector2()

func _ready():
	_change_state(STATES.IDLE)

func _change_state(new_state):
	if new_state == STATES.FOLLOW:
		path = get_parent().get_node('TileMap').find_path(position, target_position)
		if not path or len(path) == 1:
			_change_state(STATES.IDLE)
			return
		# The index 0 is the starting cell
		# we don't want the character to move back to it in this example
		target_point_world = path[1]
	_state = new_state

func _process(_delta):
	if not _state == STATES.FOLLOW:
		return
	var arrived_to_next_point = move_to(target_point_world)
	if arrived_to_next_point:
		path.remove(0)
		if len(path) == 0:
			_change_state(STATES.IDLE)
			return
		target_point_world = path[0]

# Handle the movement from point to point
func move_to(world_position):
	
	var velocity = (world_position - position).normalized() * SPEED
	if position.distance_to(world_position) <= SPEED:
		position = world_position
	else:
		position += velocity
	
	return world_position == position
