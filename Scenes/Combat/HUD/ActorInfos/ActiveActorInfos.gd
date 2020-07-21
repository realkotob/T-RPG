extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actions_left_node = $ActionsLeft

const ALLY_COLOR = Color("496d6f")
const ENEMY_COLOR = Color.red

var active_actor : Node setget set_active_actor

func set_active_actor(actor: Node):
	active_actor = actor

func new_turn():
	# Update the portrait in the portrait_node
	portrait_node.set_texture(active_actor.portrait)
	
	# Update the portrait background
	if active_actor is Enemy:
		$PortraitContainer/Background.set_modulate(ENEMY_COLOR)
	else:
		$PortraitContainer/Background.set_modulate(ALLY_COLOR)
