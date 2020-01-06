extends Node

onready var map_node = get_node("Map")
onready var map_area_node = get_node("Map/Areas")
onready var cursor_node = get_node("YSort/Cursor")
onready var combat_state_node = get_node("Combat_State")

onready var allies_array : Array = get_tree().get_nodes_in_group("Allies")
onready var actors_order : Array = allies_array

var active_actor : Node
var previous_actor : Node = null


func _ready():
	give_nodes_to_allies()
	active_actor = actors_order[0]
	setup_cursor()
	setup_combat_state()
	new_turn()


# New turn procedure, set the new active actor
func new_turn():
	previous_actor = active_actor
	first_become_last(actors_order)
	active_actor = actors_order[0]


# Put the first actor of the array at the last position
func first_become_last(array : Array) -> void:
	array.append(array[0])
	array.pop_front()


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


# Setup the combat_state_node and give it node references
func setup_combat_state() -> void:
	combat_state_node.combat_loop_node = self
	combat_state_node.setup()