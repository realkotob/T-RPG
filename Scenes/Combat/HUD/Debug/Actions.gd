extends Label

var active_actor : Node

func _ready():
	set_physics_process(false)


func setup():
	set_physics_process(true)


func _physics_process(_delta):
	if active_actor != null:
		text = "Actions left: " + active_actor.get_current_actions() as String
	else:
		text = "Actions left: "
