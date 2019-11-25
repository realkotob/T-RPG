extends Sprite

func _on_Map_path_found(path_found):
	if path_found == true:
		set_modulate(Color('#ffffff'))
	else:
		set_modulate(Color('#ff0000'))
