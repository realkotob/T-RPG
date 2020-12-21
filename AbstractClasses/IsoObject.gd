extends Node2D
class_name IsoObject

var map_node : Map = null setget set_map_node, get_map_node
var current_cell := Vector3.INF setget set_current_cell, get_current_cell

var is_ready : bool = false
var currently_visible : bool = true setget set_currently_visible, is_currently_visible

export var grid_height : int = 1 setget set_height, get_height
export var passable : bool = true setget set_passable, is_passable

#### ACCESSORS ####

func set_map_node(value: Map): map_node = value
func get_map_node() -> Map: return map_node

func set_current_cell(value: Vector3):
	var value_changed : bool = value != current_cell
	current_cell = value
	if value_changed && is_ready:
		Events.emit_signal("iso_object_cell_changed", self)

func get_current_cell() -> Vector3: return current_cell

func set_height(value : int):
	var value_changed : bool = value != grid_height
	grid_height = value
	if value_changed && is_ready:
		Events.emit_signal("iso_object_cell_changed", self)

func get_height() -> int: return grid_height

func set_passable(value : bool): passable = value
func is_passable() -> bool: return passable

func set_currently_visible(value: bool): currently_visible = value
func is_currently_visible() -> bool: return currently_visible

#### BUILT-IN ####

func _ready():
	var combat_node = get_tree().get_current_scene()
	map_node = combat_node.get_node("Map")
	
	if !map_node.is_ready: yield(map_node, "ready")
	
	# If the grid position hasn't been defined when instancied
	# Define it based on the world position
	if get_current_cell() == Vector3.INF:
		set_current_cell(map_node.get_pos_highest_cell(position))
	
	add_to_group("IsoObject")
	create()
	
	is_ready = true


#### LOGIC ####


func create():
	Events.emit_signal("iso_object_added", self)


func destroy():
	remove_from_group("IsoObject")
	Events.emit_signal("iso_object_removed", self)
	queue_free()
