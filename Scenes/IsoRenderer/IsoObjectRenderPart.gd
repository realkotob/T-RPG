extends Node2D
class_name IsoObjectRenderPart

onready var renderer = get_parent()

var altitude : int setget set_altitude, get_altitude

var current_cell : Vector3 setget set_current_cell, get_current_cell
var object_ref : Node = null setget set_object_ref, get_object_ref 

var in_view_field : bool = true setget set_in_view_field, is_in_view_field

signal cell_changed(part, cell)

#### ACCESSORS ####

func is_class(value: String): return value == "IsoObjectRenderPart" or .is_class(value)
func get_class() -> String: return "IsoObjectRenderPart"

func set_current_cell(value: Vector3):
	if current_cell != value:
		current_cell = value
		emit_signal("cell_changed", self, current_cell)

func get_current_cell() -> Vector3: return current_cell

func set_object_ref(value: Node): object_ref = value
func get_object_ref() -> Node: return object_ref

func set_in_view_field(value: bool): in_view_field = value
func is_in_view_field() -> bool: return in_view_field

func set_altitude(value: int): altitude = value
func get_altitude() -> int: return altitude


#### BUILT-IN ####

func _init(obj: Node, texture: AtlasTexture, cell: Vector3, world_pos: Vector2, alt: int = 0,
		offset := Vector2.ZERO, mod:= Color.white) -> void:
	set_current_cell(cell)
	set_object_ref(obj)
	set_modulate(mod)
	set_global_position(world_pos)
	set_altitude(alt)
	
	var sprite = Sprite.new()
	sprite.set_texture(texture)
	sprite.set_offset(offset)
	add_child(sprite, true)
	sprite.set_owner(self)


func _ready() -> void:
	if object_ref is IsoObject:
		var _err = object_ref.connect("cell_changed", self, "_on_object_cell_changed")
		_err = object_ref.connect("global_position_changed", self, "_on_object_global_position_changed")
		_err = connect("cell_changed", renderer, "_on_part_cell_changed")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_object_cell_changed(cell: Vector3):
	set_current_cell(cell + Vector3(0, 0, get_altitude()))

func _on_object_global_position_changed(world_pos: Vector2):
	set_global_position(world_pos)
