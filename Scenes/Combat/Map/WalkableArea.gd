extends YSort

const MOVE_AREA_SPRITE = preload("res://Scenes/Combat/Map/WalkableAreaSprite.tscn")


# Destroy every area instance
func clear():
	for child in get_children():
		child.queue_free()


# Draw the given area
func draw_area(cell_pos_array : Array) -> void:
	for pos in cell_pos_array:
		var new_area = MOVE_AREA_SPRITE.instance()
		new_area.set_position(pos)
		add_child(new_area)
