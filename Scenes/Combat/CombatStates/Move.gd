extends CombatStateBase

#### COMBAT MOVE STATE ####

onready var line_node := $Line
onready var combat_states_node = get_parent()

var combat_loop_node : Node

var path := PoolVector3Array()

var is_moving : bool = false

func _ready():
	yield(owner, "ready")
	
	combat_loop_node = owner
	HUD_node = owner.HUD_node
	
	var _err
	_err = cursor_node.connect("cell_changed", self, "on_cursor_change_cell")


func _process(delta: float):
	if is_moving:
		move_actor(delta)


# Empty the path and potential path arrays
func initialize_path_value():
	path = []


# When the state is entered define the actor postiton, 
# empty the path and path array, and set a path
func enter_state():
	initialize_path_value()
	HUD_node.set_every_option_disabled()
	
	if active_actor != null:
		map_node.draw_movement_area()


# Empty the path variable when the state is exited and 
func exit_state():
	initialize_path_value() # Empty the path
	line_node.set_points([]) # Empty the line
	area_node.clear()


# On click, give the active actor its destination
# Triggers the player movement
func _unhandled_input(event):
	if event is InputEventMouseButton && combat_states_node.get_state() == self:
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			if check_path(path):
				is_moving = true
				active_actor.set_current_actions(active_actor.get_current_actions() - 1)
				HUD_node.update_actions_left(active_actor.get_current_actions())
				area_node.clear() # Clear every cells in the area tilemap


# When the cursor has moved, call the function that calculate a new path
func on_cursor_change_cell(cursor_cell : Vector3):
	if combat_states_node.get_state() == self:
		if active_actor.get_state_name() == "Idle":
			set_path(cursor_cell, active_actor.get_current_cell())
			var targets = map_node.count_reachable_targets(cursor_cell)
			cursor_node.set_targets(targets)


# Ask the map for a path between current actor's cell and the cursor's cell
func set_path(cursor_cell : Vector3, actor_cell : Vector3) -> void:
	
	path = map_node.pathfinding.find_path(actor_cell, cursor_cell)
	
	var is_path_valid = check_path(path)
	if is_path_valid:
		line_node.set_points(map_node.cell_array_to_world(path))
		cursor_node.change_color(Color.white)
	else:
		line_node.set_points([])
		cursor_node.change_color(Color.red)


# Check if the path is valid, return true if it is or false if not
func check_path(path_to_check : PoolVector3Array) -> bool:
	if active_actor == null:
		return false
	
	var movements = active_actor.get_current_movements()
	return len(path_to_check) > 0 and len(path_to_check) - 1 <= movements


func move_actor(delta: float):
	if len(path) > 0:
		var target_point_world = owner.map_node.cell_to_world(path[0])
		var arrived_to_next_point = active_actor.move_to(delta, target_point_world)
		
		# If the actor is arrived to the next point, 
		# remove this point from the path and take the next for destination
		if arrived_to_next_point == true:
			active_actor.set_current_cell(path[0])
			path.remove(0)
	
	if len(path) == 0:
		is_moving = false
		active_actor.set_state("Idle")
		movement_finished()


# Trigerred when the movement is finished
func movement_finished():
	# If the active actor no longer has actions points, triggers a new turn 
	if active_actor.get_current_actions() == 0:
		emit_signal("turn_finished")
	else:
		combat_states_node.set_state("Overlook")
