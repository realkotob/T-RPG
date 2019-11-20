extends Sprite

onready var accessable = true

func toggle_state():
	accessable = !accessable
	if accessable == true:
		set_normal_color()
	else:
		set_red_color()

func set_normal_color():
	set_modulate('white')

func set_red_color():
	set_modulate('red')
