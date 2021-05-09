extends Node
class_name CombatLoop

onready var ia = $IA
onready var map_node = $Map
onready var area_node = $Map/Interactives/Areas
onready var cursor_node = $Map/Interactives/Cursor
onready var combat_state_node = $CombatState
onready var HUD_node = $HUD
onready var debug_panel = $DebugPanel
onready var pathfinder = $Map/Pathfinding
onready var allies_team = $Map/Interactives/Actors/Allies

onready var allies_array : Array = get_tree().get_nodes_in_group("Allies") setget set_future_actors_order
onready var actors_order : Array = get_tree().get_nodes_in_group("Actors") setget set_actors_order

var focused_objects_array : Array = []

var active_actor : TRPG_Actor setget set_active_actor, get_active_actor
var previous_actor : TRPG_Actor = null

var future_actors_order : Array
var is_ready : bool = false
export var fog_of_war : bool = true

signal active_actor_changed

#### ACCESSORS ####

func set_active_actor(value: TRPG_Actor):
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

func get_active_actor() -> TRPG_Actor:
	return active_actor

func set_state(state_name: String):
	combat_state_node.set_state(state_name)


#### BUILT-IN ####

func _ready() -> void:
	var _err = connect("active_actor_changed", debug_panel, "_on_active_actor_changed")
	_err = cursor_node.connect("max_z_changed", debug_panel, "_on_cursor_max_z_changed")
	_err = combat_state_node.connect("state_changed", debug_panel, "_on_combat_state_changed")
	_err = combat_state_node.connect("substate_changed", debug_panel, "_on_combat_substate_changed")
	_err = EVENTS.connect("visible_cells_changed", self, "_on_visible_cells_changed")
	_err = map_node.connect("map_generation_finished", self, "_on_map_generation_finished")
	_err = EVENTS.connect("timeline_movement_finished", self, "_on_timeline_movement_finished")
	_err = EVENTS.connect("actor_action_chosen", self, "_on_actor_action_chosen")
	_err = EVENTS.connect("actor_action_finished", self, "_on_actor_action_finished")
	_err = EVENTS.connect("actor_cell_changed", self, "_on_actor_cell_changed")
	
	HUD_node.generate_timeline(actors_order)
	focused_objects_array = [cursor_node, active_actor]
	
	# First turn trigger
	new_turn()
	
	is_ready = true
	
	var iso_object_array = get_tree().get_nodes_in_group("IsoObject")
	$Renderer.init_rendering_queue(map_node.get_layers_array(), iso_object_array)


#### LOGIC ####

# New turn procedure, set the new active_actor and previous_actor
func new_turn():
	previous_actor = active_actor
	set_active_actor(actors_order[0])
	var __ = active_actor.connect("turn_finished", self, "_on_active_actor_turn_finished")
	__ = active_actor.connect("action_spent", self, "_on_active_actor_action_spent")
	
	on_focus_changed()
	active_actor.turn_start()
	
	if active_actor.is_in_group("Allies"):
		set_state("Overlook")
	else:
		set_state("EnemyTurn")
	
	HUD_node.update_actions_left(active_actor)
	EVENTS.emit_signal("combat_new_turn_started", active_actor)


# End of turn procedure, called right before a new turn start
func end_turn():
	active_actor.disconnect("turn_finished", self, "_on_active_actor_turn_finished")
	active_actor.disconnect("action_spent", self, "_on_active_actor_action_spent")
	
	# Change the order of the timeline
	set_future_actors_order(actors_order)
	first_become_last(future_actors_order)
	
	HUD_node.move_timeline(actors_order, future_actors_order)


# Put the first actor of the array at the last position
func first_become_last(array : Array) -> void:
	var first = array.pop_front()
	array.append(first)


func update_view_field() -> void:
	for actor in actors_order:
		map_node.update_view_field(actor)


func update_view_field_rendering() -> void:
	var allies_view_field = allies_team.get_view_field()
	
	# Give every objects its visibility
	for obj in get_tree().get_nodes_in_group("IsoObject"):
		var obj_cell = obj.get_current_cell()
		var visibility = IsoObject.VISIBILITY.VISIBLE
		
		if obj_cell in allies_view_field[IsoObject.VISIBILITY.BARELY_VISIBLE]:
			visibility = IsoObject.VISIBILITY.BARELY_VISIBLE
		elif not obj_cell in allies_view_field[IsoObject.VISIBILITY.VISIBLE]:
			if obj.is_in_group("Enemies"):
				visibility = IsoObject.VISIBILITY.HIDDEN
			else:
				visibility = IsoObject.VISIBILITY.NOT_VISIBLE
		
		obj.set_visibility(visibility)
	
	$Renderer.set_visible_cells(allies_view_field)


#### INPUTS ####

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		propagate_call("on_cancel_input")
	
		get_tree().set_input_as_handled()


#### SIGNALS ####

func _on_map_generation_finished():
	update_view_field()


# Triggered when the timeline movement is finished
# Update the order of children nodes in the hierachy of the timeline to match the actor order
func _on_timeline_movement_finished():
	set_actors_order(future_actors_order)
	HUD_node.update_timeline_order(actors_order)
	
	# Call the new turn
	new_turn()


func on_focus_changed():
	$Renderer.set_focus_array([active_actor, cursor_node])

# Update the focus objects by adding a new one
func on_object_focused(focus_obj: IsoObject):
	focused_objects_array.append(focus_obj)
	$Renderer.set_focus_array(focused_objects_array)


# Update the focus objects by erasing an old one
func on_object_unfocused(focus_obj: IsoObject):
	focused_objects_array.erase(focus_obj)


func _on_active_actor_action_spent():
	HUD_node.update_actions_left(active_actor)


func _on_actor_cell_changed(_actor: TRPG_Actor):
	update_view_field()


func _on_visible_cells_changed():
	update_view_field_rendering()


func _on_actor_action_chosen(action_name: String):
	set_state(action_name.capitalize())


func _on_actor_action_finished(actor: TRPG_Actor) -> void:
	if actor == active_actor:
		if active_actor.is_in_group("Allies"):
			set_state("Overlook")
		else:
			$CombatState/EnemyTurn.enemy_action()


func _on_active_actor_turn_finished() -> void:
	end_turn()
