extends Label

var active_actor : Node

func _ready():
	set_physics_process(false)


func setup():
	set_physics_process(true)


func _physics_process(_delta):
	if active_actor != null:
		text = "Active actor: " + active_actor.name
	else:
		text = "Active actor: null"
