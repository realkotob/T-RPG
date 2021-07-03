extends CenterContainer
class_name HUD_ActorAction

var is_ready := false
var active : bool = true setget set_active, is_active


#### ACCESSORS ####

func set_active(value: bool):
	active = value
	$Light.set_visible(active)

func is_active() -> bool:
	return active

#### BUILT-IN ####

func _ready() -> void:
	is_ready = true
