extends Node2D

const MOVE_AREA_SPRITE = preload("res://Scenes/Combat/Area/WalkableAreaSprite.tscn")

signal area_created
signal area_destroyed

func _ready():
	var combat_node = get_tree().get_current_scene()
	var _err = connect("area_created", combat_node, "on_iso_object_list_changed")
	_err = connect("area_destroyed", combat_node, "on_iso_object_list_changed")


# Destroy every area instance
func clear():
	for child in get_children():
		child.destroy()
	
	emit_signal("area_destroyed")


# Draw the given area
func draw_area(cell_array : Array) -> void:
	for cell in cell_array:
		var pos = owner.cell_to_world(cell)
		var new_area = MOVE_AREA_SPRITE.instance()
		new_area.set_map_node(get_parent())
		new_area.set_current_cell(cell)
		new_area.set_position(pos)
		add_child(new_area)
	
	emit_signal("area_created")
