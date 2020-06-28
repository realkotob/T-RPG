extends Node

onready var map_node = $Map
onready var area_node = $Map/Interactives/Areas
onready var cursor_node = $Map/Interactives/Cursor
onready var combat_state_node = $CombatState
onready var HUD_node = $HUD

onready var allies_array : Array = get_tree().get_nodes_in_group("Allies")
onready var actors_order : Array = allies_array

var active_actor : Node
var previous_actor : Node = null

var future_actors_order : Array

func _ready():
	active_actor = actors_order[0]
	HUD_node.set_active_actor(active_actor)
	HUD_node.generate_timeline(actors_order)
	$Renderer.focused_object = active_actor
	
	
	# Feed the renderer with the actors and layers and hide it
	var layers_array : Array = []
	for child in map_node.get_children():
		if child is MapLayer:
			layers_array.append(child)
	
	for actor in actors_order:
		actor.set_visible(false)
	
	$Renderer.set_layers_array(layers_array)
	on_iso_object_list_changed()


# New turn procedure, set the new active_actor and previous_actor
func new_turn():
	previous_actor = active_actor
	active_actor = actors_order[0]
	
	$Renderer.focused_object = active_actor
	
	# Triggers the new_turn method of the new active_actor
	active_actor.new_turn()
	
	# Propagate the active actor where its needed
	HUD_node.set_active_actor(active_actor)
	combat_state_node.set_active_actor(active_actor)
	combat_state_node.set_state("Overlook")


# End of turn procedure, called right before a new turn start
func end_turn():
	# Change the order of the timeline
	future_actors_order = actors_order
	first_become_last(future_actors_order)
	
	HUD_node.move_timeline(actors_order, future_actors_order)
	yield()


# Put the first actor of the array at the last position
func first_become_last(array : Array) -> void:
	array.append(array[0])
	array.pop_front()


# Triggered when the active actor finished his turn
func on_active_actor_turn_finished():
	end_turn()


# Triggered when the timeline movement is finished
# Update the order of children nodes in the hierachy of the timeline to match the actor order
func on_timeline_movement_finished():
	actors_order = future_actors_order
	HUD_node.update_timeline_order(actors_order)
	new_turn()


# Update the iso object list of the renderer
# Called each time a iso object is added or removed from the scene
func on_iso_object_list_changed():
	$Renderer.set_objects_array(get_tree().get_nodes_in_group("IsoObject"))
