extends Node

onready var map_node = get_node("Map")
onready var map_area_node = get_node("Map/Areas")
onready var cursor_node = get_node("YSort/Cursor")

onready var allies_array : Array = get_tree().get_nodes_in_group("Allies")
onready var actors_order : Array = allies_array

var active_actor : Node
var previous_actor : Node = null

signal validation_button

func _ready():
	give_nodes_to_allies()
	setup_cursor()
	active_actor = actors_order[0]
	new_turn()


# On click, notify the active actor
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		emit_signal("validation_button")


# New turn procedure, set the new active actor
func new_turn():
	previous_actor = active_actor
	first_become_last(actors_order)
	active_actor = actors_order[0]
	connect_actor(previous_actor, false)
	connect_actor(active_actor, true)


# Put the first actor of the array at the last position
func first_become_last(array : Array) -> void:
	array.append(array[0])
	array.pop_front()


# Connect/Disconnect the given actor, based on the value of the connect argument.
# true = connect, false = disconnect
func connect_actor(actor : Node, connect : bool) -> void:
	var _err
	if connect == true:
		_err = connect("validation_button", actor.find_node("Idle"), "_on_GameLoop_validation_button")
	elif is_connected("validation_button", actor.find_node("Idle"), "_on_GameLoop_validation_button"):
		disconnect("validation_button", actor.find_node("Idle"), "_on_GameLoop_validation_button")


# Give the allies all the node reference it needs
func give_nodes_to_allies() -> void:
	for ally in allies_array:
		ally.cursor_node = cursor_node
		ally.map_node = map_node
		ally.map_area_node = map_area_node
		ally.setup()

# Setup the cursor and give it node references
func setup_cursor() -> void:
	cursor_node.map_node = map_node
	cursor_node.setup()