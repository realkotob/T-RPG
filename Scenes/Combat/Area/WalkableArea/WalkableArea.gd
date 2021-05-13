extends Node2D
class_name AreaContainer

const MAX_INSTANCE_PER_FRAME : int = 10

onready var map_node = owner

var area_dict = {
	"move" : preload("res://Scenes/Combat/Area/WalkableArea/WalkableArea.tscn"),
	"damage" : preload("res://Scenes/Combat/Area/DamageArea/DamageArea.tscn"),
	"view": preload("res://Scenes/Combat/Area/ViewArea/ViewArea.tscn")
}

signal area_created
signal area_destroyed


# Destroy every area instance
func clear(type_name: String = ""):
	if type_name == "":
		for container in get_children():
			clear_container(container)
	else:
		var container = get_node(type_name.capitalize())
		clear_container(container)


# Destroy every area instance in the given container
func clear_container(container: Node) -> void:
	var area_array = container.get_children()
	for i in range(area_array.size()):
		if i % MAX_INSTANCE_PER_FRAME == 0:
			yield(get_tree(), "idle_frame")
		var area = area_array[i]
		area.destroy()
	
	emit_signal("area_destroyed")


# Draw the given area, at the given positions contained in the cell_array
func draw_area(cell_array : Array, area_type_name: String) -> void:
	var new_area_type: PackedScene = null
	var container = get_node(area_type_name.capitalize())
	
	var area_dict_keys = area_dict.keys()
	if area_type_name in area_dict_keys:
		new_area_type = area_dict[area_type_name]
	
	for i in range(cell_array.size()):
		if i % MAX_INSTANCE_PER_FRAME == 0:
			yield(get_tree(), "idle_frame")
		
		var cell = cell_array[i]
		var slope_type = map_node.get_cell_slope_type_v3(cell)
		var pos = owner.cell_to_world(cell)
		var new_area = new_area_type.instance()
		new_area.set_current_cell(cell - Vector3(0, 0, 0.5) * int(slope_type != 0))
		new_area.set_position(pos)
		new_area.set_slope_type(slope_type)
		container.call_deferred("add_child", new_area)
	
	emit_signal("area_created")


# Return the cell position of every area currently drawn in an array
func get_area_cells() -> PoolVector3Array:
	var area_cell_array : PoolVector3Array = []
	for child in get_children():
		area_cell_array.append(child.get_current_cell())
	
	return area_cell_array
