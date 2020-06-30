extends Node2D

const MOVE_AREA_SPRITE = preload("res://Scenes/Combat/Area/WalkableAreaSprite.tscn")


# Destroy every area instance
func clear():
	for child in get_children():
		child.destroy()


# Draw the given area
func draw_area(cell_array : Array) -> void:
	for cell in cell_array:
		var pos = owner.cell_to_world(cell)
		if is_cell_already_drawn(pos):
			continue
		var new_area = MOVE_AREA_SPRITE.instance()
		new_area.set_map_node(get_parent())
		new_area.set_grid_position(cell)
		new_area.set_position(pos)
		add_child(new_area)



# Return true if a cell is already drawn at the given position
# Else retrun false
func is_cell_already_drawn(pos: Vector2) -> bool:
	for child in get_children():
		if child.get_position() == pos:
			return true
	return false
