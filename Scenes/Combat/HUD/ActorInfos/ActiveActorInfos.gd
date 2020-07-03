extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actions_left_node = $ActionsLeft

var active_actor : Node setget set_active_actor

func set_active_actor(actor: Node):
	active_actor = actor
	
	# Update the portrait in the portrait_node
	if "portrait" in active_actor:
		portrait_node.set_texture(active_actor.portrait)
