extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actions_left_node = $ActionsLeft
onready var HP_jauge = $Jauges/HP
onready var MP_jauge = $Jauges/MP


const ALLY_COLOR = Color("496d6f")
const ENEMY_COLOR = Color.red


func _ready():
	var _err = Events.connect("combat_new_turn_started", self, "_on_combat_new_turn_started")
	_err = Events.connect("active_actor_stats_changed", self, "_on_active_actor_stats_changed")


#### LOGIC ####


func update_portrait(actor: Actor):
	# Update the portrait in the portrait_node
	portrait_node.set_texture(actor.portrait)
	
	# Update the portrait background
	if actor is Enemy:
		$PortraitContainer/Background.set_modulate(ENEMY_COLOR)
	else:
		$PortraitContainer/Background.set_modulate(ALLY_COLOR)


func update_jauges(actor: Actor):
	HP_jauge.set_max(actor.get_max_HP())
	HP_jauge.set_value(actor.get_current_HP())
	
	MP_jauge.set_max(actor.get_max_MP())
	MP_jauge.set_value(actor.get_current_MP())


#### SIGNAL RESPONSES ####

func _on_combat_new_turn_started(actor: Actor):
	update_portrait(actor)
	update_jauges(actor)

func _on_active_actor_stats_changed(actor: Actor):
	update_jauges(actor)
