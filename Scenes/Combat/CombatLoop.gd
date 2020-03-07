extends Node

onready var map_node = get_node("Map")
onready var map_area_node = get_node("Map/Areas")
onready var cursor_node = get_node("YSort/Cursor")
onready var combat_state_node = get_node("CombatState")
onready var HUD_node = get_node("HUD")

onready var allies_array : Array = get_tree().get_nodes_in_group("Allies")
onready var actors_order : Array = allies_array

onready var children_array = get_children()

var active_actor : Node
var previous_actor : Node = null


func _ready():
	active_actor = actors_order[0]
	setup_children()
	new_turn()


# New turn procedure, set the new active actor
func new_turn():
	previous_actor = active_actor
	first_become_last(actors_order)
	active_actor = actors_order[0]
	HUD_node.set_active_actor(active_actor)


# Put the first actor of the array at the last position
func first_become_last(array : Array) -> void:
	array.append(array[0])
	array.pop_front()


# Give references to the children node and call their setup method
func setup_children():
	# Treat the cursor node as a direct child
	children_array.append(cursor_node)
	
	# Treat the characters as direct children
	children_array += allies_array
	
	for child in children_array:
		if "map_node" in child:
			child.map_node = map_node
		
		if "cursor_node" in child:
			child.cursor_node = cursor_node
		
		if "map_area_node" in child:
			child.map_area_node = map_area_node
		
		if "combat_loop_node" in child:
			child.combat_loop_node = self
		
		if "combat_state_node" in child:
			child.combat_state_node = combat_state_node
		
		if "HUD_node" in child:
			child.HUD_node = HUD_node
		
		if child.has_method("setup"):
			child.setup()

