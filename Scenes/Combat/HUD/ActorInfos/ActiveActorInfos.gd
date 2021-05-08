extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actions_left_node = $ActionsLeft
onready var HP_gauge = $Gauges/HP
onready var MP_gauge = $Gauges/MP


const ALLY_COLOR = Color("496d6f")
const ENEMY_COLOR = Color.red


func _ready():
	var _err = EVENTS.connect("combat_new_turn_started", self, "_on_combat_new_turn_started")
	_err = EVENTS.connect("actor_stats_changed", self, "_on_actor_stats_changed")


#### LOGIC ####


func update_portrait(actor: TRPG_Actor):
	# Update the portrait in the portrait_node
	portrait_node.set_texture(actor.portrait)
	
	# Update the portrait background
	if actor.is_in_group("Enemies"):
		$PortraitContainer/Background.set_modulate(ENEMY_COLOR)
	else:
		$PortraitContainer/Background.set_modulate(ALLY_COLOR)


func update_gauges(actor: TRPG_Actor, instantanious : bool = false):
	HP_gauge.set_gauge_max_value(actor.get_max_HP())
	HP_gauge.set_gauge_value(actor.get_current_HP(), !instantanious)
	
	MP_gauge.set_gauge_max_value(actor.get_max_MP())
	MP_gauge.set_gauge_value(actor.get_current_MP(), !instantanious)


#### SIGNAL RESPONSES ####

func _on_combat_new_turn_started(actor: TRPG_Actor):
	update_portrait(actor)
	update_gauges(actor, true)

func _on_actor_stats_changed(actor: TRPG_Actor):
	if actor == owner.active_actor:
		update_gauges(actor)
