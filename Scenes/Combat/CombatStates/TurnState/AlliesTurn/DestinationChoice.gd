extends CombatStateBase

#### DESTINATION CHOICE STATE ###

onready var combat_states_node = get_parent()

var path := PoolVector3Array()
var reachable_area := PoolVector3Array()

var cursor_cell := Vector3.INF

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
		reachable_area = owner.map_node.draw_movement_area(owner.active_actor)


# Empty the path variable when the state is exited and 
func exit_state():
	path = []
	reachable_area = []
	cursor_cell = Vector3.INF
	owner.map_node.clear_area()
	EVENTS.emit_signal("clear_movement_arrow")


#### LOGIC ####

# Ask the IsoMap for a path between current actor's cell and the cursor's cell
func set_path(actor_cell : Vector3) -> void:
	path = owner.pathfinder.find_path(actor_cell, cursor_cell)
	EVENTS.emit_signal("generate_movement_arrow", path)


#### INPUTS ####

# On click, give the active actor its destination
# Triggers the player movement
func _unhandled_input(event):
	if event is InputEventMouseButton && is_current_state():
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			if cursor_cell in reachable_area:
				owner.active_actor.move(path)
				owner.map_node.clear_area()
				states_machine.set_state("MoveAnimation")


func on_cancel_input():
	if is_current_state():
		owner.set_turn_state("Overlook")


#### SIGNAL REPONSES ####


# When the cursor has moved,
# call the function that calculate a new path
func _on_cursor_cell_changed(_cursor: Cursor, cell: Vector3):
	if is_current_state():
		cursor_cell = cell
		
		if cell in reachable_area:
			set_path(owner.active_actor.get_current_cell())
		else:
			EVENTS.emit_signal("clear_movement_arrow")
