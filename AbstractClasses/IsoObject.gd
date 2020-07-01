extends Node2D
class_name IsoObject

var map_node : Map = null setget set_map_node, get_map_node
var grid_position := Vector3.INF setget set_grid_position, get_grid_position
export var grid_height : int = 1 setget set_grid_height, get_grid_height

signal iso_object_created
signal iso_object_destroyed


#### ACCESSORS ####

func set_map_node(value: Map):
	map_node = value

func get_map_node() -> Map:
	return map_node

func set_grid_position(value: Vector3):
	grid_position = value

func get_grid_position() -> Vector3:
	return grid_position

func set_grid_height(value : int):
	grid_height = value

func get_grid_height() -> int:
	return grid_height


#### BUILT-IN ####

func _ready():
	var combat_node = get_tree().get_current_scene()
	map_node = combat_node.get_node("Map")
	if !map_node.is_ready:
		yield(map_node, "ready")
	
	# If the grid position hasn't been defined when instancied
	# Define it based on the world position
	if get_grid_position() == Vector3.INF:
		set_grid_position(map_node.get_pos_highest_cell(position))
	
	var _err = connect("iso_object_created", combat_node, "on_iso_object_list_changed")
	_err = connect("iso_object_destroyed", combat_node, "on_iso_object_list_changed")
	add_to_group("IsoObject")
	emit_signal("iso_object_created")


#### LOGIC ####

func destroy():
	remove_from_group("IsoObject")
	emit_signal("iso_object_destroyed")
	queue_free()
