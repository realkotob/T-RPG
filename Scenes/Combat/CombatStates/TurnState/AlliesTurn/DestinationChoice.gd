extends CombatStateBase

#### DESTINATION CHOICE STATE ###

onready var combat_states_node = get_parent()

var path := PoolVector3Array()

#### BUILT-IN ####

func _ready():
	var _err = EVENTS.connect("cursor_cell_changed", self, "_on_cursor_cell_changed")

#### VIRTUAL ####


# When the state is entered define the actor's postiton, 
# empty the path and path array, and set a path
func enter_state():
	if !is_current_state():
		return
	
	.enter_state()
	
	path = []
	
	if owner.active_actor != null:
		owner.map_node.draw_movement_area()


# Empty the path variable when the state is exited and 
func exit_state():
	path = []
	EVENTS.emit_signal("clear_movement_arrow")
	
	owner.area_node.clear()


#### LOGIC ####

# Ask the IsoMap for a path between current actor's cell and the cursor's cell
func set_path(cursor_cell : Vector3, actor_cell : Vector3) -> void:
	EVENTS.emit_signal("clear_movement_arrow")
	path = owner.pathfinder.find_path(actor_cell, cursor_cell)
	
	var is_path_valid = check_path(path)
	if is_path_valid:
		EVENTS.emit_signal("generate_movement_arrow", path)
		owner.cursor_node.change_color(Color.white)
	else:
		owner.cursor_node.change_color(Color.red)


# Check if the path is valid, return true if it is or false if not
func check_path(path_to_check : PoolVector3Array) -> bool:
	if owner.active_actor == null or path.size() <= 1:
		return false
	
	var movements = owner.active_actor.get_current_movements()
	return len(path_to_check) > 0 and len(path_to_check) - 1 <= movements


#### INPUTS ####

# On click, give the active actor its destination
# Triggers the player movement
func _unhandled_input(event):
	if event is InputEventMouseButton && is_current_state():
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			if check_path(path):
				owner.active_actor.move(path)
				owner.area_node.clear() # Clear every cells in the area tilemap
				states_machine.set_state("Animation")


func on_cancel_input():
	if is_current_state():
		owner.set_turn_state("Overlook")


#### SIGNAL REPONSES ####


# When the cursor has moved, 
# call the function that calculate a new path
func _on_cursor_cell_changed(_cursor: Cursor, cell: Vector3):
	if is_current_state():
		if owner.active_actor.get_state_name() == "Idle":
			set_path(cell, owner.active_actor.get_current_cell())
