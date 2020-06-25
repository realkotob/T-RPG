tool
extends Node2D
class_name MapLayer

func set_children_offset(offset : Vector2):
	for child in get_children():
		if child is TileMap:
			child.set_offset(offset)
