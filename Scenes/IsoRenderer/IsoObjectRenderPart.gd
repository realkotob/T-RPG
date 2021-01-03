extends Node
class_name IsoObjectRenderPart

var atlas_texture : AtlasTexture setget set_atlas_texture, get_atlas_texture
var current_cell : Vector3 setget set_current_cell, get_current_cell
var object_ref : IsoObject = null setget set_object_ref, get_object_ref 
var texture_offset := Vector2.ZERO setget set_texture_offset, get_texture_offset

#### ACCESSORS ####

func is_class(value: String): return value == "IsoObjectRenderPart" or .is_class(value)
func get_class() -> String: return "IsoObjectRenderPart"

func set_atlas_texture(value: AtlasTexture): atlas_texture = value
func get_atlas_texture() -> AtlasTexture: return atlas_texture

func set_current_cell(value: Vector3): current_cell = value
func get_current_cell() -> Vector3: return current_cell

func set_object_ref(value: IsoObject): object_ref = value
func get_object_ref() -> IsoObject: return object_ref

func set_texture_offset(value: Vector2): texture_offset = value
func get_texture_offset() -> Vector2: return texture_offset

#### BUILT-IN ####

func _init(obj: IsoObject, texture: AtlasTexture, cell: Vector3, offset := Vector2.ZERO) -> void:
	set_atlas_texture(texture)
	set_current_cell(cell)
	set_object_ref(obj)
	set_texture_offset(offset)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
