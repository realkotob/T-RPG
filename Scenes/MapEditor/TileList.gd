extends Control
class_name TileList

onready var item_list = $Panel/Control/ItemList
onready var category_container = $Panel/Control/CategoryContainer

var map : IsoMap = null setget set_map, get_map 
var current_category : int = 0

enum TILE_TYPE {
	TILE,
	OBSTACLE,
	DECORATION
}

signal tile_selected(tile_id)


#### ACCESSORS ####

func is_class(value: String): return value == "TileList" or .is_class(value)
func get_class() -> String: return "TileList"

func set_map(value: IsoMap): map = value
func get_map() -> IsoMap: return map

#### BUILT-IN ####

func _ready() -> void:
	var __ = item_list.connect("item_selected", self, "_on_item_list_item_selected")
	_generate_categories()


#### VIRTUALS ####



#### LOGIC ####


func _generate_categories() -> void:
	for key in TILE_TYPE.keys():
		var button = Button.new()
		button.set_text(key.capitalize())
		
		category_container.call_deferred("add_child", button)
		button.connect("button_down", self, "_on_category_button_down", [button])


func update_tile_list(map_node: IsoMap = null, category: int = 0) -> void:
	if map_node != null:
		map = map_node
	
	var tileset : TileSet = map.get_tileset()
	
	for tile_id in tileset.get_tiles_ids():
		var tile_category = tileset.tile_get_z_index(tile_id)
		if tile_category != category:
			continue
		
		var tile_name = tileset.tile_get_name(tile_id)
		var tile_texture = tileset.tile_get_texture(tile_id)
		var texture_region = tileset.tile_get_region(tile_id)
		
		if tileset.tile_get_tile_mode(tile_id) != TileSet.SINGLE_TILE:
			var subtile_size = tileset.autotile_get_size(tile_id)
			var icon_coord = tileset.autotile_get_icon_coordinate(tile_id)
			texture_region = Rect2(texture_region.position + subtile_size * icon_coord, subtile_size)
		
		var atlas_texture = AtlasTexture.new()
		atlas_texture.set_atlas(tile_texture)
		atlas_texture.set_region(texture_region)

		item_list.add_item(tile_name, atlas_texture)


#### INPUTS ####

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tab"):
		set_visible(!is_visible())


#### SIGNAL RESPONSES ####

func _on_category_button_down(button: Button) -> void:
	item_list.clear()
	current_category = button.get_index()
	update_tile_list(map, current_category)


func _on_item_list_item_selected(item_list_id: int) -> void:
	var item_text = item_list.get_item_text(item_list_id)
	var tile_id = map.get_tileset().find_tile_by_name(item_text)
	emit_signal("tile_selected", tile_id)
