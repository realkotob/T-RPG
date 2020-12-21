extends Node2D
class_name AreaContainer


var area_dict = {
	"move" : preload("res://Scenes/Combat/Area/WalkableArea/WalkableArea.tscn"),
	"damage" : preload("res://Scenes/Combat/Area/DamageArea/DamageArea.tscn"),
	"view": preload("res://Scenes/Combat/Area/ViewArea/ViewArea.tscn")
}

signal area_created
signal area_destroyed


# Destroy every area instance
func clear():
	for child in get_children():
		child.destroy()
	
	emit_signal("area_destroyed")


# Draw the given area, at the given positions contained in the cell_array
func draw_area(cell_array : Array, area_type_name: String) -> void:
	var new_area_type: PackedScene = null
	
	var area_dict_keys = area_dict.keys()
	if area_type_name in area_dict_keys:
		new_area_type = area_dict[area_type_name]
	
	for cell in cell_array:
		var pos = owner.cell_to_world(cell)
		var new_area = new_area_type.instance()
		new_area.set_map_node(get_parent())
		new_area.set_current_cell(cell)
		new_area.set_position(pos)
		add_child(new_area)
	
	emit_signal("area_created")


# Return the cell position of every area currently drawn in an array
func get_area_cells() -> PoolVector3Array:
	var area_cell_array : PoolVector3Array = []
	for child in get_children():
		area_cell_array.append(child.get_current_cell())
	
	return area_cell_array
