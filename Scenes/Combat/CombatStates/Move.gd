extends CombatStateBase

#### COMBAT MOVE STATE ####

onready var line_node := $Line
onready var combat_states_node = get_parent()

var combat_loop_node : Node
var HUD_node : Node
var map_node : Node
var cursor_node : Node
var area_node : Node

var active_actor : Node

var path := PoolVector2Array()

signal path_valid
signal active_actor_turn_finished

func _ready():
	yield(owner, "ready")
	
	combat_loop_node = owner
	map_node = owner.map_node
	cursor_node = owner.cursor_node
	HUD_node = owner.HUD_node
	area_node = owner.area_node
	
	active_actor = owner.active_actor
	
	var _err
	_err = connect("path_valid", cursor_node, "_on_path_valid")
	_err = cursor_node.connect("cursor_change_position", self, "on_cursor_change_position")
	_err = connect("active_actor_turn_finished", combat_loop_node, "on_active_actor_turn_finished")


# Empty the path and potential path arrays
func initialize_path_value():
	path = []


# When the state is entered define the actor postiton, empty the path and path array, and set a path
func enter_state():
	initialize_path_value()
	
	if active_actor != null:
		var pos = active_actor.get_global_position()
		set_path(get_viewport().get_mouse_position(), pos)
		
		area_node.draw_movement_area(pos, active_actor.get_current_movements())
	
	var _err = active_actor.move_node.connect("movement_finished", self, "on_movement_finished")


# Empty the path variable when the state is exited and 
func exit_state():
	initialize_path_value() # Empty the path
	line_node.set_points([]) # Empty the line
	area_node.clear() # Clear every cells in the area tilemap
	
	active_actor.move_node.disconnect("movement_finished", self, "on_movement_finished")


# On click, give the active actor its destination
# Triggers the player movement
func _unhandled_input(event):
	if event is InputEventMouseButton && combat_states_node.get_state() == self:
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			if check_path(path):
				active_actor.move_along_path(path) # Move the actor
				active_actor.set_current_actions(active_actor.get_current_actions() - 1)
				HUD_node.update_actions_left(active_actor.get_current_actions())


# When cursor as moved, call the function that calculate a new path
func on_cursor_change_position(cursor_pos : Vector2):
	if combat_states_node.get_state() == self:
		set_path(cursor_pos, active_actor.get_global_position())


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
	if active_actor == null:
		return false
	
	var movements = active_actor.get_current_movements()
	if len(path_to_check) > 0 and len(path_to_check) - 1 <= movements:
		return true
	else:
		return false


# Trigerred when the movement is finished
func on_movement_finished():
	combat_states_node.set_state("Overlook") # Set the state to overlook
	
	# If the active actor no longer has actions points, triggers a new turn 
	if active_actor.get_current_actions() == 0:
		emit_signal("active_actor_turn_finished")
