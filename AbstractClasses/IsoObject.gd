extends Node2D
class_name IsoObject

var grid_position := Vector3.INF setget set_grid_position, get_grid_position

signal iso_object_created
signal iso_object_destroyed


func set_grid_position(value: Vector3):
	grid_position = value

func get_grid_position() -> Vector3:
	return grid_position


func _ready():
	var combat_node = get_tree().get_current_scene()
	
	var _err = connect("iso_object_created", combat_node, "on_iso_object_list_changed")
	_err = connect("iso_object_destroyed", combat_node, "on_iso_object_list_changed")
	add_to_group("IsoObject")
	emit_signal("iso_object_created")


func destroy():
	remove_from_group("IsoObject")
	emit_signal("iso_object_destroyed")
	queue_free()
