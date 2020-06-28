extends IsoObject

onready var sprite_node = get_node("Sprite")

var mouse_pos := Vector2()
var map_node : Node

signal cursor_change_cell

#### ACCESSORS ####

func set_grid_position(value: Vector3):
	if value != grid_position:
		grid_position = value
		emit_signal("cursor_change_cell", grid_position)

func get_grid_position() -> Vector3:
	return grid_position

#### BUILT-IN FUNCTIONS ####

func _ready():
	yield(owner, "ready")
	map_node = owner


func _physics_process(_delta):
	# Get the mouse position
	mouse_pos = get_global_mouse_position()
	mouse_pos.y += 8
	
	# Snap to the grid
	set_grid_position(map_node.get_pos_highest_cell(mouse_pos))
	
	# Set the cursor to the right position
	set_position(map_node.cell_to_world(grid_position))


func _on_path_valid(is_path_valid : bool):
	sprite_node.change_color(is_path_valid)
