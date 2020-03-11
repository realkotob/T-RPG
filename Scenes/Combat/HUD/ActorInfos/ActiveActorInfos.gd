extends Control

onready var portrait_node = $PortraitContainer/Portrait

var active_actor : Node setget set_active_actor

func set_active_actor(actor: Node):
	active_actor = actor
	if "portrait" in active_actor:
		portrait_node.set_texture(active_actor.portrait)
