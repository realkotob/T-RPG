extends IsoObject
class_name Cursor

onready var sprite_node = get_node("Sprite")

var mouse_pos := Vector2()
var grid2D_position := Vector2.ZERO
var max_z : int = INF setget set_max_z, get_max_z
var current_cell_max_z : int = INF
var previous_cell := Vector3.INF

signal cell_changed
signal max_z_changed

#### ACCESSORS ####

func set_grid_position(value: Vector3):
	if value != grid_position && value != Vector3.INF:
		if map_node.is_position_valid(value):
			previous_cell = grid_position
			grid_position = value
			emit_signal("cell_changed", grid_position, previous_cell)


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


func update_cursor_pos():
	# Get the mouse position
	mouse_pos = get_global_mouse_position()
	mouse_pos.y += 8
	
	# Snap to the grid
	var new_grid2D_pos = map_node.world_to_ground0(mouse_pos)
	if new_grid2D_pos != grid2D_position:
		grid2D_position = new_grid2D_pos
		
		var cell_stack = map_node.get_cell_stack_at_pos(mouse_pos)
		var next_cell = find_same_x_cell(cell_stack, previous_cell)
		if next_cell == null:
			next_cell = find_same_y_cell(cell_stack, previous_cell)
		if next_cell == null:
			next_cell = map_node.get_pos_highest_cell(mouse_pos)
		
		set_grid_position(next_cell)
		
		current_cell_max_z = int(next_cell.z)
		set_max_z(int(grid_position.z + 1))
	
	# Set the cursor to the right position
	set_position(map_node.cell_to_world(grid_position))



func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("PreviousLayer"):
			set_max_z(int(max_z - 1))
			set_grid_position(map_node.get_pos_highest_cell(mouse_pos, max_z))
		if Input.is_action_just_pressed("NextLayer"):
			set_max_z(int(max_z + 1))
			set_grid_position(map_node.get_pos_highest_cell(mouse_pos, max_z))


func _on_path_valid(is_path_valid : bool):
	sprite_node.change_color(is_path_valid)


# find a cell in the array that has the same x than the previous_cell and return it
# Return null if no cell were found
func find_same_x_cell(cell_stack: PoolVector3Array, prev_cell: Vector3):
	for cell in cell_stack:
		if cell.x == prev_cell.x:
			return cell
	return null


# find a cell in the array that has the same y than the previous_cell and return it
# Return null if no cell were found
func find_same_y_cell(cell_stack: PoolVector3Array, prev_cell: Vector3):
	for cell in cell_stack:
		if cell.y == prev_cell.y:
			return cell
	return null
