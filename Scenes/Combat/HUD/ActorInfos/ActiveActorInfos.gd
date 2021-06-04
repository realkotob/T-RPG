extends Control

onready var portrait_node = $PortraitContainer/Portrait
onready var actor_data_container = $ActorData
onready var actions_left_node = $ActorData/ActionsLeft
onready var gauge_container = $ActorData/Gauges
onready var altitude_label = $ActorData/Altitude
onready var HP_gauge = $ActorData/Gauges/HP
onready var MP_gauge = $ActorData/Gauges/MP

const ALLY_COLOR = Color("496d6f")
const ENEMY_COLOR = Color.red

var previous_actor : TRPG_Actor = null
var current_actor : TRPG_Actor = null setget set_current_actor, get_current_actor

signal current_actor_changed(previous_actor, new_actor)

#### ACCESSORS ####

func set_current_actor(value: TRPG_Actor): 
	previous_actor = current_actor
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
	var is_ally = current_actor.is_team_side(ActorTeam.TEAM_TYPE.ALLY)
	
	actor_data_container.set_visible(is_ally)
	_update_gauges(instantanious)
	_update_portrait()
	_update_altitude_label(current_actor.get_current_cell().z)
	actions_left_node.update_display(current_actor)


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
	HP_gauge.set_gauge_value(current_actor.get_current_HP(), instantanious)
	
	MP_gauge.set_gauge_max_value(current_actor.get_max_MP())
	MP_gauge.set_gauge_value(current_actor.get_current_MP(), instantanious)


func _update_altitude_label(altitude: float):
	altitude_label.set_text("Alt: " + String(altitude))


#### SIGNAL RESPONSES ####

func _on_combat_new_turn_started(actor: TRPG_Actor):
	set_current_actor(actor)


func _on_actor_stats_changed(actor: TRPG_Actor):
	if actor == current_actor:
		var is_first_actor = previous_actor != null
		_update_gauges(is_first_actor)


func _on_current_actor_changed(new_actor: TRPG_Actor):
	if previous_actor != null:
		previous_actor.disconnect("action_finished", self, "_on_current_actor_action_finished")
		previous_actor.disconnect("cell_changed", self, "_on_current_actor_cell_changed")
	
	if new_actor != null:
		var __ = new_actor.connect("action_finished", self, "_on_current_actor_action_finished")
		__ = new_actor.connect("cell_changed", self, "_on_current_actor_cell_changed")
	
	_update_actor_info(true)


func _on_current_actor_action_finished(_action_name: String):
	actions_left_node.update_display(current_actor)


func _on_current_actor_cell_changed(cell: Vector3):
	_update_altitude_label(cell.z)
