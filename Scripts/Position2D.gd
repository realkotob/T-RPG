extends Position2D

export(float) var SPEED = 5.0

enum STATES { IDLE, FOLLOW }
var state = null

var path = []
var potential_path = []
var target_point_world := Vector2()


func _change_state(new_state):
	if new_state == STATES.FOLLOW:
		if path == null || len(path) <= 1:
			_change_state(STATES.IDLE)
			return
		# The index 0 is the starting cell
		# we don't want the character to move back to it in this example
		target_point_world = path[1]
	state = new_state


# Move the player from point to point
func _process(_delta):
	if state != STATES.FOLLOW:
		return
	var arrived_to_next_point = move_to(target_point_world)
	if arrived_to_next_point:
		path.remove(0)
		if len(path) == 0:
			_change_state(STATES.IDLE)
			return
		target_point_world = path[0]

# Handle the movement from point to point, return true if the character is arrived
func move_to(world_position):
	
	var velocity = (world_position - position).normalized() * SPEED
	if position.distance_to(world_position) <= SPEED:
		position = world_position
	else:
		position += velocity
	
	return world_position == position

func _on_cursor_change_position(cursor_pos):
	potential_path = get_tree().get_root().get_node("Master/Map").find_path(position, cursor_pos)

# On click, give the active character its destination
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		path = potential_path
		_change_state(STATES.FOLLOW)

