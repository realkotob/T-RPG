extends Position2D

var mouse_pos := Vector2()
var cursor_cell := Vector2()
var cursor_pos := Vector2()
onready var grid := Vector2(32, 16)
onready var map_node := get_parent().get_node("Map")

signal cursor_change_position

func snap_to_iso_grid(mouse_position, iso_grid):
	
	var iso_pos = Vector2()
	# Mouse world position
	var mouse_x = int(mouse_position.x)
	var mouse_y = int(mouse_position.y)
	# Size of a isometric cell
	var grid_x = int(iso_grid.x)
	var grid_y = int(iso_grid.y)
	
	
	# Snap to the cartesian grid for the x value (with a 0.5 grid_x offset to matche the iso), and half the grid for the y
	iso_pos.x = ((mouse_x / grid_x) * grid_x ) + grid_x * 0.5 * int(sign(mouse_x))
	iso_pos.y = ((mouse_y / (grid_y/2)) * (grid_y/2))
	
	# If the mouse is between two cartesian rows in the y axis
	# Put the cursor on the closest cell in the x axis
	if int(abs(int(mouse_y) / grid_y/2)) % 2 == 1:
		if iso_pos.x == 0:
			iso_pos.x += grid_x / 2
		elif abs((mouse_x % grid_x)) >= abs((grid_x/2)):
			iso_pos.x += grid_x / 2 * int(sign(mouse_x))
		else:
			iso_pos.x -= grid_x / 2 * int(sign(mouse_x))
	
	
	return iso_pos

func _physics_process(_delta):
	# Get the mouse position
	mouse_pos = get_global_mouse_position()
	mouse_pos.y += 8
	
	# Snap to the grid
	#cursor_pos = snap_to_iso_grid(mouse_pos, grid)
	cursor_cell = map_node.world_to_map(mouse_pos)
	cursor_pos = map_node.map_to_world(cursor_cell)
	cursor_pos.y -= 8
	
	if position != cursor_pos:
		emit_signal("cursor_change_position", cursor_pos)
	
	# Set the cursor to the right position
	set_position(cursor_pos)