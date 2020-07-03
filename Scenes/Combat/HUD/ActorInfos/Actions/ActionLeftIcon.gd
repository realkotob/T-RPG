extends CenterContainer

var active : bool = true setget set_active, is_active

#### ACCESSORS ####

func set_active(value: bool):
	active = value
	$Light.set_visible(active)

func is_active() -> bool:
	return active
