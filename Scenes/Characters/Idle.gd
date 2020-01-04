extends StateBase

var map_node : TileMap

var character_node : Node
var stats_node : Node

var path := PoolVector2Array()
var potential_path := PoolVector2Array()

signal path_chosen
signal path_valid
signal draw_movement_area


# Connect signals whenever the parent is ready
func setup():
	var _err


# Empty the path and potential path arrays
func initialize_path_value():
	path = []
	potential_path = []


# Check if the path is valid or not every frames, if it is, set the state to Move
func update(_host, _delta):
	var is_path_valid = check_path(path)
	if is_path_valid == true:
		emit_signal("path_chosen", path)
		return "Move"


# When the state is entered define the actor postiton, empty the path and potential_path array, and set a potential_path
func enter_state(host):
	var pos
	if character_node != null:
		pos = character_node.get_position()
		initialize_path_value()
		set_potential_path(host.get_viewport().get_mouse_position(), pos)
	
		if stats_node != null:
			emit_signal("draw_movement_area", pos, stats_node.get_actual_movements())


# When the state is exited, empty the path and potential path array
func exit_state(_host):
	initialize_path_value()


# On click, give the active character its destination
func _on_GameLoop_validation_button() -> void:
	path = potential_path


# When cursor as moved, call the function that calculate a new path
func on_cursor_change_position(cursor_pos : Vector2):
	set_potential_path(cursor_pos, character_node.global_position)


# Ask Astar for a path between current actor's position and cursor position
func set_potential_path(cursor_pos : Vector2, char_pos : Vector2) -> void:
	potential_path = map_node.find_path(char_pos, cursor_pos)
	var is_path_valid = check_path(potential_path)
	emit_signal("path_valid", is_path_valid)


# Check if the path is valid, return true or false
func check_path(path_to_check : PoolVector2Array) -> bool:
	if stats_node == null:
		return false
	
	var movements = stats_node.get_actual_movements()
	if len(path_to_check) > 0 and len(path_to_check) - 1 <= movements:
		return true
	else:
		return false
