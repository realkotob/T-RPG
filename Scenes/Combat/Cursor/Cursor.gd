extends Node2D

onready var sprite_node = get_node("Sprite")

var mouse_pos := Vector2()
var cursor_cell := Vector2()
var cursor_pos := Vector2()

var map_node

signal cursor_change_position

func _ready():
	yield(owner, "ready")
	map_node = owner



func _physics_process(_delta):
	# Get the mouse position
	mouse_pos = get_global_mouse_position()
	mouse_pos.y += 8
	
	# Snap to the grid
	cursor_cell = map_node.ground_0_node.world_to_map(mouse_pos)
	cursor_pos = map_node.ground_0_node.map_to_world(cursor_cell)
	cursor_pos.y -= 8
	
	if position != cursor_pos:
		# This signal is connected to and from the Overlook combat state
		emit_signal("cursor_change_position", cursor_pos)
	
	# Set the cursor to the right position
	set_position(cursor_pos)


func _on_path_valid(is_path_valid : bool):
	sprite_node.change_color(is_path_valid)
