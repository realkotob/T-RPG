extends CombatStateBase

#### COMBAT MOVE STATE ####

onready var line_node := $Line
onready var combat_states_node = get_parent()

var map_node : TileMap
var character_node : Node
var move_node : Node
var cursor_node : Node
var area_node : Node
var combat_loop_node : Node

var path := PoolVector2Array()

signal path_valid


func setup():
	var _err
	_err = connect("path_valid", cursor_node, "_on_path_valid")
	_err = cursor_node.connect("cursor_change_position", self, "on_cursor_change_position")


# Empty the path and potential path arrays
func initialize_path_value():
	path = []


# When the state is entered define the actor postiton, empty the path and path array, and set a path
func enter_state():
	var pos
	if character_node != null:
		pos = character_node.get_global_position()
		initialize_path_value()
		set_path(get_viewport().get_mouse_position(), pos)
		
		area_node.draw_movement_area(pos, character_node.get_actual_movements())
	
	var _err = character_node.move_node.connect("movement_finished", self, "on_movement_finished")


# Empty the path variable when the state is exited and 
func exit_state():
	initialize_path_value() # Empty the path
	line_node.set_points([]) # Empty the line
	area_node.clear() # Clear every cells in the area tilemap
	character_node.move_node.disconnect("movement_finished", self, "on_movement_finished")


# On click, give the active actor its destination
func _unhandled_input(event):
	if event is InputEventMouseButton && combat_states_node.get_state() == self:
		if event.get_button_index() == BUTTON_LEFT:
			if check_path(path):
				character_node.move_along_path(path) # Move the actor


# When cursor as moved, call the function that calculate a new path
func on_cursor_change_position(cursor_pos : Vector2):
	if combat_states_node.get_state() == self:
		set_path(cursor_pos, character_node.get_global_position())


# Ask Astar for a path between current actor's position and cursor position
func set_path(cursor_pos : Vector2, char_pos : Vector2) -> void:
	path = map_node.find_path(char_pos, cursor_pos)
	var is_path_valid = check_path(path)
	
	if is_path_valid:
		line_node.set_points(path)
	else:
		line_node.set_points([])
	
	# Notify the cursor that the path is valid
	emit_signal("path_valid", is_path_valid)


# Check if the path is valid, return true if it is or false if not
func check_path(path_to_check : PoolVector2Array) -> bool:
	if character_node == null:
		return false
	
	var movements = character_node.get_actual_movements()
	if len(path_to_check) > 0 and len(path_to_check) - 1 <= movements:
		return true
	else:
		return false


# Trigerred when the movement is finished
func on_movement_finished():
	combat_states_node.set_state("Overlook") # Set the state to overlook
