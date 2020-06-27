extends Node2D

onready var sprite_node = get_node("Sprite")

var mouse_pos := Vector2()
var cursor_cell := Vector3() setget set_cursor_cell, get_cursor_cell

var map_node : Node

signal cursor_change_cell

#### ACCESSORS ####

func set_cursor_cell(value: Vector3):
	if value != cursor_cell:
		cursor_cell = value
		emit_signal("cursor_change_cell", cursor_cell)

func get_cursor_cell() -> Vector3:
	return cursor_cell

#### BUILT-IN FUNCTIONS ####

func _ready():
	yield(owner, "ready")
	map_node = owner


func _physics_process(_delta):
	# Get the mouse position
	mouse_pos = get_global_mouse_position()
	mouse_pos.y += 8
	
	# Snap to the grid
	set_cursor_cell(map_node.get_pos_highest_cell(mouse_pos))
	
	# Set the cursor to the right position
	set_position(map_node.cell_to_world(cursor_cell))


func _on_path_valid(is_path_valid : bool):
	sprite_node.change_color(is_path_valid)
