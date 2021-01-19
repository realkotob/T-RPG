extends IsoObject
class_name Cursor

onready var sprite_node = get_node("Sprite")

var map_node = null

var mouse_pos := Vector2()
var grid2D_position := Vector2.ZERO
var max_z : int = INF setget set_max_z, get_max_z
var current_cell_max_z : int = INF

signal max_z_changed

#### ACCESSORS ####

func set_current_cell(value: Vector3):
	if value != current_cell:
		current_cell = value
		if !map_node.is_outside_map_bounds(value):
			Events.emit_signal("cursor_cell_changed", self, current_cell)
			Events.emit_signal("iso_object_cell_changed", self)
			emit_signal("cell_changed", current_cell)
		else:
			change_color(Color.transparent)


func set_max_z(value : int):
	if value != max_z && value > 0 && value <= current_cell_max_z + 1:
		max_z = value
		emit_signal("max_z_changed", max_z)


func get_max_z() -> int:
	return max_z

#### BUILT-IN FUNCTIONS ####

func _ready():
	yield(owner, "ready")
	map_node = owner


func _process(_delta):
	update_cursor_pos()


#### LOGIC ####


func update_cursor_pos():
	# Get the mouse position
	mouse_pos = get_global_mouse_position()
	
	# Snap to the grid
	var new_grid2D_cell = map_node.world_to_ground_z(mouse_pos, 0)
	if new_grid2D_cell != grid2D_position:
		grid2D_position = new_grid2D_cell
		
		var cell_stack = map_node.get_cell_stack_at_pos(mouse_pos)
		set_current_cell(find_wanted_cell(cell_stack))
		
#		current_cell_max_z = cell_stack.size() - 1
#		set_max_z(int(current_cell.z + 1))
	
	# Set the cursor to the right position
	set_global_position(map_node.cell_to_world(current_cell))


func move_cursor(movement: Vector2):
	var future_2D_cell = Vector2(current_cell.x + movement.x, current_cell.y + movement.y) 
	var highest_layer = map_node.get_cell_highest_layer(future_2D_cell)
	set_current_cell(Vector3(future_2D_cell.x, future_2D_cell.y, highest_layer))


func change_color(color : Color):
	sprite_node.set_modulate(color)


# Try to get the cell the player wanted to point at and returns it
func find_wanted_cell(cell_stack : PoolVector3Array) -> Vector3:
	var next_cell := Vector3.INF
	
	if cell_stack.size() > 1:
		next_cell = find_nearest_z_cell(cell_stack, current_cell)
	elif cell_stack.size() == 1:
		next_cell = map_node.get_pos_highest_cell(mouse_pos)

# Get the highest cell at the mouse position based on the current cell z
#### DOESN'T BEHAVE AS EXPECTED FOR NOW ####
#	if next_cell == Vector3.INF:
#		var ground0_cell = map_node.world_to_ground_z(mouse_pos, current_cell.z)
#		return map_node.find_2D_cell(ground0_cell)
	
	return next_cell


# Find the nearest cell on the z axis, in the cell stack,
# from the previous cell
func find_nearest_z_cell(cell_stack: PoolVector3Array, cur_cell: Vector3) -> Vector3:
	var nearest_z_cell = Vector3.INF
	var closest_cell_diff : float = INF
	for cell in cell_stack:
		var new_dif = abs(cur_cell.z - cell.z) 
		if new_dif == 0:
			return cell
		if new_dif < closest_cell_diff:
			nearest_z_cell = cell
			closest_cell_diff = new_dif
	
	return nearest_z_cell


#### INPUT ####

func _input(_event):
	if Input.is_action_just_pressed("click"):
		Events.emit_signal("tiles_shake", Vector2(current_cell.x, current_cell.y), 3)
	
	if Input.is_action_just_pressed("ui_up"):
		move_cursor(Vector2.UP)
	
	elif Input.is_action_just_pressed("ui_right"):
		move_cursor(Vector2.RIGHT)
	
	elif Input.is_action_just_pressed("ui_down"):
		move_cursor(Vector2.DOWN)

	elif Input.is_action_just_pressed("ui_left"):
		move_cursor(Vector2.LEFT)

	if !Input.is_action_just_pressed("NextLayer") && !Input.is_action_just_pressed("PreviousLayer"):
		return
	
	var cell_stack = Array(map_node.get_cell_stack_at_pos(mouse_pos))
	var index = cell_stack.find(current_cell)
	
	if cell_stack.empty():
		return
	
	if Input.is_action_just_pressed("PreviousLayer"):
		index = wrapi(index - 1, 0, cell_stack.size())
	
	if Input.is_action_just_pressed("NextLayer"):
		index = wrapi(index + 1, 0, cell_stack.size())
	
	set_current_cell(cell_stack[index])



# Show/Hide the targets counter
func hide_target_counter(value: bool):
	$Targets.set_visible(!value)


# Update the target counter label with a new given value
func set_targets(targets: int):
	$Targets.set_text(String(targets))
