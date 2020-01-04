extends Button

onready var WHITE := Color('#ffffff')
onready var RED := Color('#ff0000')

func _ready():
	var _err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("mouse_exited", self, "on_mouse_exited")

func on_mouse_entered():
	set_modulate(RED)

func on_mouse_exited():
	set_modulate(WHITE)