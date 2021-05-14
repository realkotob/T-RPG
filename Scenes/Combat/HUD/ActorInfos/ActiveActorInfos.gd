extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actions_left_node = $ActionsLeft
onready var HP_gauge = $Gauges/HP
onready var MP_gauge = $Gauges/MP


const ALLY_COLOR = Color("496d6f")
const ENEMY_COLOR = Color.red

var current_actor : TRPG_Actor = null setget set_current_actor, get_current_actor

signal current_actor_changed(actor)

#### ACCESSORS ####

func set_current_actor(value: TRPG_Actor): 
	if value != current_actor:
		current_actor = value
		emit_signal("current_actor_changed", current_actor)

func get_current_actor() -> TRPG_Actor: return current_actor

#### BUILT-IN ####

func _ready():
	var _err = EVENTS.connect("combat_new_turn_started", self, "_on_combat_new_turn_started")
	_err = EVENTS.connect("actor_stats_changed", self, "_on_actor_stats_changed")
	_err = connect("current_actor_changed", self, "_on_current_actor_changed")


#### LOGIC ####

func _update_actor_info(instantanious : bool = false):
	_update_portrait()
	_update_gauges(instantanious)


func _update_portrait():
	# Update the portrait in the portrait_node
	portrait_node.set_texture(current_actor.portrait)
	
	# Update the portrait background
	if current_actor.is_team_side(ActorTeam.TEAM_TYPE.ENEMY):
		$PortraitContainer/Background.set_modulate(ENEMY_COLOR)
	else:
		$PortraitContainer/Background.set_modulate(ALLY_COLOR)


func _update_gauges(instantanious : bool = false):
	HP_gauge.set_gauge_max_value(current_actor.get_max_HP())
	HP_gauge.set_gauge_value(current_actor.get_current_HP(), !instantanious)
	
	MP_gauge.set_gauge_max_value(current_actor.get_max_MP())
	MP_gauge.set_gauge_value(current_actor.get_current_MP(), !instantanious)


#### SIGNAL RESPONSES ####

func _on_combat_new_turn_started(actor: TRPG_Actor):
	if actor.is_team_side(ActorTeam.TEAM_TYPE.ALLY):
		set_current_actor(actor)
	else:
		set_current_actor(null)


func _on_actor_stats_changed(actor: TRPG_Actor):
	if actor == current_actor:
		_update_gauges()


func _on_current_actor_changed(actor: TRPG_Actor):
	if actor != null:
		_update_actor_info()
	
	set_visible(actor != null)
