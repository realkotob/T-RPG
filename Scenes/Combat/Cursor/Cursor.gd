extends IsoObject
class_name Cursor

onready var sprite_node = get_node("Sprite")

var mouse_pos := Vector2()
var grid2D_position := Vector2.ZERO
var max_z : int = INF setget set_max_z, get_max_z
var current_cell_max_z : int = INF

signal cell_changed
signal max_z_changed

#### ACCESSORS ####

func set_grid_position(value: Vector3):
	if value != grid_position && value != Vector3.INF:
		if map_node.is_position_valid(value):
			grid_position = value
			emit_signal("cell_changed", grid_position)


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
		var highest_cell = map_node.get_pos_highest_cell(mouse_pos)
		current_cell_max_z = int(highest_cell.z)
		set_grid_position(highest_cell)
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
