extends Node

onready var action_menu_node = $ActionMenu
onready var action_buttons_array = $ActionMenu.get_children()
onready var active_actor_infos_node = $ActiveActorInfos
onready var actions_left_node = $ActiveActorInfos/ActionsLeft
onready var timeline_node = $Timeline
onready var height_node = $ActiveActorInfos/Height

func _ready():
	action_menu_node.set_visible(true)
	active_actor_infos_node.set_visible(true)
	timeline_node.set_visible(true)


# Generate the timeline form an array of actors
# Called at the start of the combat by the combat Node
func generate_timeline(actors_array : Array):
	timeline_node.generate_timeline(actors_array)


# Called when a turn end, move the timeline to be in the right disposition
func move_timeline(current_order: Array, future_order: Array):
	timeline_node.move_timeline(current_order, future_order)


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


# Update the display of actions left each time it's called
# Usually called on each new turn, and after each actions
# Can also be called when a malus is applied to the actor
func update_actions_left(actor: TRPG_Actor):
	actions_left_node.update_display(actor)
