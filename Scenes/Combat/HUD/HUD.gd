extends Node

onready var debug_node : Node = $Debug
onready var action_menu_node = $ActionMenu
onready var action_buttons_array = $ActionMenu.get_children()
onready var debug_labels_array = debug_node.get_children()
onready var active_actor_infos_node = $ActiveActorInfos
onready var actions_left_node = $ActiveActorInfos/ActionsLeft
onready var timeline_node = $TimeLineStates/Timeline
onready var height_node = $ActiveActorInfos/Height

var combat_loop_node : Node
var combat_state_node : Node
var active_actor : Object

func _ready():
	
	for child in get_children():
		if "combat_loop_node" in child:
			child.combat_loop_node = combat_loop_node
	
	# Set every HUD node visible (expect the debug)
	action_menu_node.set_visible(true)
	active_actor_infos_node.set_visible(true)
	timeline_node.set_visible(true)


# Generate the timeline form an array of actors
# Called at the start of the combat by the combat Node
func generate_timeline(actors_array : Array):
	timeline_node.generate_timeline(actors_array)


# Called when a turn end, move the timeline to be in the right disposition
func move_timeline(current_actors_order: Array, future_actors_order: Array):
	$TimeLineStates.move_timeline(current_actors_order, future_actors_order)


# Rearrange the hierarchy of nodes of the timeline so it correspond the actors order
# Called at the end of a turn by the combat Node
func update_timeline_order(actor_order : Array):
	timeline_node.update_timeline_order(actor_order)


# Update the height display
func update_height(height: int):
	height_node.set_text("H: " + String(height))


# Set the whole actor HUD visible/invisible
func hide_active_actor_infos(value : bool):
	active_actor_infos_node.set_visble(!value)


# Change the active actor in the HUD
# Generaly called by CombatLoop when the active actor change
func set_active_actor(actor : Node):
	for label in debug_labels_array:
		if "active_actor" in label:
			label.active_actor = actor
	
	active_actor_infos_node.set_active_actor(actor)


# Update the display of actions left each time it's called
# Usually called on each new turn, and after each actions
# Can also be called when a malus is applied to the actor
func update_actions_left(value : int):
	var actions_left = clamp(value, 0, 3) as int
	actions_left_node.update_display(actions_left)


# Change the combat state label
func on_combat_state_changed(state : Node):
	for label in debug_labels_array:
		if "combat_state" in label:
			label.combat_state = state


# Set the debug labels visible/invisible on ui_cancel
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		debug_node.set_visible(!debug_node.is_visible())
		
		# Desactivate the physics process of the labels when they are invisible
		for label in debug_labels_array:
			label.set_physics_process(debug_node.is_visible())
