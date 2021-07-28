extends Node2D
class_name MapEditor

onready var renderer = $Renderer
onready var tile_list = $UI/TileList

export var map_scene_path : String = ""
var map : IsoMap = null

var selected_tile_id : int = -1 setget set_selected_tile_id, get_selected_tile_id

#### ACCESSORS ####

func is_class(value: String): return value == "MapEditor" or .is_class(value)
func get_class() -> String: return "MapEditor"

func set_selected_tile_id(value: int): selected_tile_id = value
func get_selected_tile_id() -> int: return selected_tile_id


#### BUILT-IN ####

func _ready() -> void:
	var __ = tile_list.connect("tile_selected", self, "_on_tile_list_tile_selected")
	
	if map_scene_path != "" && DirNavHelper.is_file_existing(map_scene_path):
		_change_map(map_scene_path)


#### VIRTUALS ####



#### LOGIC ####

func _change_map(map_path: String) -> void:
	if DirNavHelper.is_file_existing(map_path):
		map_scene_path = map_path
	
	var map_scene = ResourceLoader.load(map_scene_path, "PackedScene")
	
	# Ask the user if he/she want to save the file
	if is_instance_valid(map):
		map.queue_free()
		renderer.clear_tiles()
	
	map = map_scene.instance()
	var __ = map.connect("map_generation_finished", self, "_on_map_generation_finished")
	
	add_child(map)
	map.set_owner(self)
	
	__ = map.cursor.connect("cell_changed", self, "_on_cursor_cell_changed")
	map.cursor.set_display_on_empty_cell(true)


func add_ghost_tilemaps() -> void:
	var tilemap : IsoTileMap = null
	
	for layer in map.get_layers_array():
		tilemap = IsoTileMap.new()
		tilemap.set_mode(TileMap.MODE_ISOMETRIC)
		tilemap.set_cell_size(GAME.TILE_SIZE)
		tilemap.set_tileset(map.get_tileset())
		tilemap.set_name("Ghost")
		tilemap.set_modulate(Color(1.0, 1.0, 1.0, 0.3))
		layer.call_deferred("add_child", tilemap)
		tilemap.call_deferred("set_owner", self)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_map_generation_finished() -> void:
	renderer.init_rendering_queue(map.get_layers_array())
	tile_list.update_tile_list(map)
	add_ghost_tilemaps()


func _on_tile_list_tile_selected(tile_id: int) -> void:
	set_selected_tile_id(tile_id)


func _on_cursor_cell_changed(from: Vector3, to: Vector3) -> void:
	if from == to or selected_tile_id == -1:
		return
	
	var layer = map.get_layer(to.z)
	var ghost_tilemap : TileMap = layer.get_node("Ghost")
	
	ghost_tilemap.clear()
	ghost_tilemap.set_cell(int(to.x), int(to.y), selected_tile_id)
