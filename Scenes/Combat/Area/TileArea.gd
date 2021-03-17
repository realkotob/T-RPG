extends IsoObject
class_name TileArea

onready var sprite_node = $Sprite

var slope_type : int = 0 setget set_slope_type, get_slope_type

#### ACCESSORS ####

func set_slope_type(value: int): slope_type = value
func get_slope_type() -> int: return slope_type


#### BUILT-IN ####

func _ready():
	set_visible(false)
	var texture_pos = sprite_node.get_region_rect().position
	var sprite_size = GAME.TILE_SIZE if slope_type == 0 else GAME.TILE_SIZE * Vector2(1, 2)
	
	texture_pos.y = GAME.TILE_SIZE.y + (slope_type - 1) * sprite_size.y
	
	sprite_node.set_region_rect(Rect2(texture_pos, sprite_size))
	
	sprite_node.emit_signal("sprite_texture_changed", sprite_node)
