extends Label

var combat_state : Node

func _ready():
	set_physics_process(false)


func setup():
	set_physics_process(true)


func _physics_process(_delta):
	if combat_state != null:
		text = "Combat State: " + combat_state.name
	else:
		text = "Combat State: null"
