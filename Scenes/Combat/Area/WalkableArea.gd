extends Node2D

const MOVE_AREA_SPRITE = preload("res://Scenes/Combat/Area/WalkableAreaSprite.tscn")


# Destroy every area instance
func clear():
	for child in get_children():
		if child is IsoObject:
			child.destroy()


# Draw the given area
func draw_area(cell_array : Array) -> void:
	for cell in cell_array:
		var new_area = MOVE_AREA_SPRITE.instance()
		new_area.set_grid_position(cell)
		new_area.set_position(owner.cell_to_world(cell))
		add_child(new_area)
