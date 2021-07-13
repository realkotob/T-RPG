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

func is_class(value: String): return value == "Cursor" or .is_class(value)
func get_class() -> String: return "Cursor"

func set_current_cell(value: Vector3):
	if value != current_cell:
		if map_node.is_cell_ground(value):
			var previous_cell = current_cell
			current_cell = value
			EVENTS.emit_signal("cursor_cell_changed", self, current_cell)
			EVENTS.emit_signal("iso_object_cell_changed", self)
			emit_signal("cell_changed", previous_cell, current_cell)
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
	var new_grid2D_cell = map_node.world_to_layer_2D_cell(mouse_pos, 0)
	if new_grid2D_cell != grid2D_position:
		grid2D_position = new_grid2D_cell
		
		var cell_stack = map_node.get_cell_stack_at_pos(mouse_pos)
		set_current_cell(find_wanted_cell(cell_stack))
	
	# Set the cursor to the right position
	set_global_position(map_node.cell_to_world(current_cell))


func get_target() -> TRPG_DamagableObject:
	return map_node.get_damagable_on_cell(current_cell)


func move_cursor(movement: Vector2):
	var future_2D_cell = Vector2(current_cell.x + movement.x, current_cell.y + movement.y) 
	var highest_layer = map_node.get_cell2D_highest_z(future_2D_cell)
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
	if Input.is_action_just_pressed("ui_up"):
		move_cursor(Vector2.UP)
	
	elif Input.is_action_just_pressed("ui_right"):
		move_cursor(Vector2.RIGHT)
	
	elif Input.is_action_just_pressed("ui_down"):
		move_cursor(Vector2.DOWN)

	elif Input.is_action_just_pressed("ui_left"):
		move_cursor(Vector2.LEFT)

	elif Input.is_action_just_pressed("click"):
		EVENTS.emit_signal("click_at_cell", current_cell)

	var cell_stack = Array(map_node.get_cell_stack_at_pos(mouse_pos))
	var index = cell_stack.find(current_cell)
	
	if cell_stack.empty():
		return
	
	if !Input.is_action_just_pressed("NextLayer") && !Input.is_action_just_pressed("PreviousLayer"):
		return
	
	if Input.is_action_just_pressed("PreviousLayer"):
		index = wrapi(index - 1, 0, cell_stack.size())
	
	if Input.is_action_just_pressed("NextLayer"):
		index = wrapi(index + 1, 0, cell_stack.size())
	
	set_current_cell(cell_stack[index])
