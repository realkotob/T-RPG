extends Node2D
class_name AreaContainer

const MOVE_AREA = preload("res://Scenes/Combat/Area/WalkableArea/WalkableArea.tscn")
const DAMAGE_AREA = preload("res://Scenes/Combat/Area/DamageArea/DamageArea.tscn")

enum area_type {
	MOVE
	DAMAGE
}


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


# Draw the given area, at the given positions contained in the cell_array
func draw_area(cell_array : Array, type: int = area_type.MOVE) -> void:
	var new_area_type: PackedScene = null
	match(type):
		area_type.MOVE: new_area_type = MOVE_AREA
		area_type.DAMAGE: new_area_type = DAMAGE_AREA
	
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
