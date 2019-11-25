extends "res://Scripts/States.gd"

onready var map_node = get_tree().get_root().get_node("Master/Map")

var path : PoolVector2Array
var potential_path : PoolVector2Array
var position : Vector2

signal path_chosen

func update(_host, _delta):
	if len(path) > 1:
		emit_signal("path_chosen", path)
		return "move"

func enter_state(host):
	position = host.position
	_reinitialize_path_value()
	set_potential_path(host.get_viewport().get_mouse_position())

func exit_state(_host):
	_reinitialize_path_value()

# On click, give the active character its destination
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		path = potential_path

# Ask Astar for a path between current actor's position and cursor position
func set_potential_path(cursor_pos):
	potential_path = map_node.find_path(position, cursor_pos)

func _reinitialize_path_value():
	path = []
	potential_path = []