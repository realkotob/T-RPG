extends Node
class_name CombatLoop

onready var map_node = $Map
onready var area_node = $Map/Interactives/Areas
onready var cursor_node = $Map/Interactives/Cursor
onready var combat_state_node = $CombatState
onready var HUD_node = $HUD
onready var debug_panel = $DebugPanel
onready var pathfinder = $Map/Pathfinding

onready var allies_array : Array = get_tree().get_nodes_in_group("Allies") setget set_future_actors_order
onready var actors_order : Array = get_tree().get_nodes_in_group("Actors") setget set_actors_order

var focused_objects_array : Array = []

var active_actor : Actor setget set_active_actor, get_active_actor
var previous_actor : Actor = null

var future_actors_order : Array
var is_ready : bool = false
var fog_of_war : bool = true

var visible_cells := PoolVector3Array()

signal active_actor_changed
#warning-ignore:unused_signal
signal actor_action_finished(actor)

#### ACCESSORS ####

func set_active_actor(value: Actor):
	if value != active_actor:
		focused_objects_array.erase(active_actor)
		if active_actor != null: active_actor.set_active(false)
		active_actor = value
		active_actor.set_active(true)
		focused_objects_array.append(active_actor)
		emit_signal("active_actor_changed", active_actor)


func set_actors_order(value: Array):
	actors_order = value.duplicate()

func set_future_actors_order(value: Array):
	future_actors_order = value.duplicate()

func get_active_actor() -> Actor:
	return active_actor

func set_state(state_name: String):
	combat_state_node.set_state(state_name)


#### BUILT-IN ####

func _ready() -> void:
	var _err = connect("active_actor_changed", debug_panel, "_on_active_actor_changed")
	_err = cursor_node.connect("max_z_changed", debug_panel, "_on_cursor_max_z_changed")
	_err = combat_state_node.connect("state_changed", debug_panel, "_on_combat_state_changed")
	_err = Events.connect("visible_cells_changed", self, "_on_visible_cells_changed")
	_err = area_node.connect("area_created", self, "on_area_created")
	
	HUD_node.generate_timeline(actors_order)
	focused_objects_array = [cursor_node, active_actor]
	
	# Feed the renderer with the actors and layers and hide it
	var layers_array : Array = []
	for child in map_node.get_children():
		if child is MapLayer:
			layers_array.append(child)
	
	for actor in actors_order:
		map_node.update_view_field(actor)
	
	# First turn trigger
	new_turn()
	
	is_ready = true
	
	var iso_object_array = get_tree().get_nodes_in_group("IsoObject")
	$Renderer.init_rendering_queue(layers_array, iso_object_array)

	$Map.set_obstacles(fetch_obstacles(iso_object_array))


#### LOGIC ####

# New turn procedure, set the new active_actor and previous_actor
func new_turn():
	previous_actor = active_actor
	set_active_actor(actors_order[0])
	
	on_focus_changed()
	
	combat_state_node.set_state("Overlook")
	
	active_actor.turn_start()
	HUD_node.update_actions_left(active_actor)
	Events.emit_signal("combat_new_turn_started", active_actor)


# End of turn procedure, called right before a new turn start
func end_turn():
	# Change the order of the timeline
	set_future_actors_order(actors_order)
	first_become_last(future_actors_order)
	
	HUD_node.move_timeline(actors_order, future_actors_order)


# Put the first actor of the array at the last position
func first_become_last(array : Array) -> void:
	var first = array.pop_front()
	array.append(first)


# Get every unpassable object form the IsoOject group 
func fetch_obstacles(iso_object_array: Array) -> Array:
	var unpassable_objects : Array = []
	for object in iso_object_array:
		if !object.is_passable():
			unpassable_objects.append(object)
	
	return unpassable_objects


#### SIGNALS ####

# Triggered when the active actor finished his turn
func on_active_actor_turn_finished():
	end_turn()


# Triggered when the timeline movement is finished
# Update the order of children nodes in the hierachy of the timeline to match the actor order
func on_timeline_movement_finished():
	set_actors_order(future_actors_order)
	HUD_node.update_timeline_order(actors_order)
	
	# Call the new turn
	new_turn()


func on_area_created():
	pass

func on_focus_changed():
	$Renderer.set_focus_array([active_actor, cursor_node])

# Update the focus objects by adding a new one
func on_object_focused(focus_obj: IsoObject):
	focused_objects_array.append(focus_obj)
	$Renderer.set_focus_array(focused_objects_array)


# Update the focus objects by erasing an old one
func on_object_unfocused(focus_obj: IsoObject):
	focused_objects_array.erase(focus_obj)


func on_action_spent():
	HUD_node.update_actions_left(active_actor)
	
	yield(self, "actor_action_finished")
	if active_actor.get_current_actions() == 0:
		end_turn()
	else:
		set_state("Overlook")


func on_actor_wait():
	set_state("Wait")


func _on_visible_cells_changed():
	visible_cells = []
	for ally in allies_array:
		for cell in ally.get_view_field():
			if not cell in visible_cells:
				visible_cells.append(cell)
	
	for obj in get_tree().get_nodes_in_group("IsoObject"):
		obj.set_currently_visible(obj.get_current_cell() in visible_cells)
	
	
	$Renderer.set_visible_cells(visible_cells)
