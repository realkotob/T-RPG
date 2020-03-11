extends Sprite

const WHITE := Color('#ffffff')
const RED := Color('#ff0000')

func change_color(path_valid):
	if path_valid == true:
		set_modulate(WHITE)
	else:
		set_modulate(RED)
