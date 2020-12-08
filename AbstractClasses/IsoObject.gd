extends Node2D
class_name IsoObject

var map_node : Map = null setget set_map_node, get_map_node
var current_cell := Vector3.INF setget set_current_cell, get_current_cell

var is_ready : bool = false

export var grid_height : int = 1 setget set_grid_height, get_grid_height
export var passable : bool = true setget set_passable, is_passable

signal created
signal destroyed
signal position_changed

#### ACCESSORS ####

func set_map_node(value: Map): map_node = value
func get_map_node() -> Map: return map_node

func set_current_cell(value: Vector3):
	var value_changed : bool = value != current_cell
	current_cell = value
	if value_changed && is_ready:
		emit_signal("position_changed")

func get_current_cell() -> Vector3: return current_cell

func set_grid_height(value : int):
	var value_changed : bool = value != grid_height
	grid_height = value
	if value_changed && is_ready:
		emit_signal("position_changed")

func get_grid_height() -> int: return grid_height

func set_passable(value : bool):
	var value_changed : bool = value != passable
	passable = value
	if value_changed && is_ready:
		emit_signal("position_changed")

func is_passable() -> bool: return passable

#### BUILT-IN ####

func _ready():
	var combat_node = get_tree().get_current_scene()
	map_node = combat_node.get_node("Map")
	
	if !map_node.is_ready: yield(map_node, "ready")
	
	# If the grid position hasn't been defined when instancied
	# Define it based on the world position
	if get_current_cell() == Vector3.INF:
		set_current_cell(map_node.get_pos_highest_cell(position))
	
	var _err = connect("created", combat_node, "on_iso_object_list_changed")
	_err = connect("destroyed", combat_node, "on_iso_object_list_changed")
	add_to_group("IsoObject")
	
	# If the scene is already loaded (ie if the object is instanciated later)
	if !combat_node.get("is_ready") or combat_node.is_ready == true:
		create()
	
	is_ready = true


#### LOGIC ####


func create():
	emit_signal("created")


func destroy():
	remove_from_group("IsoObject")
	emit_signal("destroyed")
	queue_free()
