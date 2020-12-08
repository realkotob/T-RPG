extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actions_left_node = $ActionsLeft

const ALLY_COLOR = Color("496d6f")
const ENEMY_COLOR = Color.red


func _ready():
	var _err = Events.connect("combat_new_turn_started", self, "on_combat_new_turn_started")


func on_combat_new_turn_started(actor: Actor):
	# Update the portrait in the portrait_node
	portrait_node.set_texture(actor.portrait)
	
	# Update the portrait background
	if actor is Enemy:
		$PortraitContainer/Background.set_modulate(ENEMY_COLOR)
	else:
		$PortraitContainer/Background.set_modulate(ALLY_COLOR)
