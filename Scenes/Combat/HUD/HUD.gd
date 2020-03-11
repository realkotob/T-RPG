extends Control

onready var debug_node : Node = $Debug

onready var action_buttons_array = $ActionMenu.get_children()
onready var debug_labels_array = debug_node.get_children()
onready var active_actor_infos_node = $ActiveActorInfos

var combat_state_node: Node

func setup():
	for button in action_buttons_array:
		if "combat_state_node" in button:
			button.combat_state_node = combat_state_node
		
		if button.has_method("setup"):
			button.setup()
	
	for label in debug_labels_array:
		
		if label.has_method("setup"):
			label.setup()


func hide_active_actor_infos(value : bool):
	active_actor_infos_node.set_visble(!value)


# Change the active actor in the HUD
# Generaly called by CombatLoop when the active actor change
func set_active_actor(actor : Node):
	for label in debug_labels_array:
		if "active_actor" in label:
			label.active_actor = actor
	
	active_actor_infos_node.set_active_actor(actor)


# Change the combat state label
func on_combat_state_changed(state : Node):
	for label in debug_labels_array:
		if "combat_state" in label:
			label.combat_state = state


# Set the debug labels invisible when  
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		debug_node.set_visible(!debug_node.is_visible())
		
		# Desactivate the physics process of the labels when they are invisible
		for label in debug_labels_array:
			label.set_physics_process(debug_node.is_visible())
