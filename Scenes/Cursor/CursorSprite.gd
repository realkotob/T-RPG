extends Sprite

func _on_path_valid(path_valid):
	if path_valid == true:
		set_modulate(Color('#ffffff'))
	else:
		set_modulate(Color('#ff0000'))
