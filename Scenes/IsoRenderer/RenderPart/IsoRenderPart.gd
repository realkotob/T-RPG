extends RenderPart
class_name IsoRenderPart

onready var renderer = get_parent()

#### ACCESSORS ####

func is_class(value: String): return value == "IsoRenderPart" or .is_class(value)
func get_class() -> String: return "IsoRenderPart"


#### BUILT-IN ####

func _init(obj: Node, texture: AtlasTexture, cell: Vector3, world_pos: Vector2, alt: int = 0,
		offset := Vector2.ZERO, mod:= Color.white, sprite_mod:= Color.white) -> void:
	set_current_cell(cell)
	set_object_ref(obj)
	set_modulate(mod)
	set_global_position(world_pos)
	set_altitude(alt)
	
	var sprite = Sprite.new()
	sprite.set_texture(texture)
	sprite.set_offset(offset)
	sprite.set_modulate(sprite_mod)
	add_child(sprite, true)
	sprite.set_owner(self)


func _ready() -> void:
	var _err = object_ref.connect("cell_changed", self, "_on_object_cell_changed")
	_err = object_ref.connect("global_position_changed", self, "_on_object_global_position_changed")
	_err = object_ref.connect("modulate_changed", self, "_on_object_modulate_changed")
	_err = connect("cell_changed", renderer, "_on_part_cell_changed")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_object_cell_changed(cell: Vector3):
	set_current_cell(cell + Vector3(0, 0, get_altitude()))

func _on_object_global_position_changed(world_pos: Vector2):
	set_global_position(world_pos)

func _on_object_modulate_changed(mod: Color):
	set_modulate(mod)
