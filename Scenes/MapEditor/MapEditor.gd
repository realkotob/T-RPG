extends Node2D
class_name MapEditor

onready var renderer = $Renderer

export var map_scene_path : String = ""
var map : IsoMap = null

#### ACCESSORS ####

func is_class(value: String): return value == "MapEditor" or .is_class(value)
func get_class() -> String: return "MapEditor"


#### BUILT-IN ####

func _ready() -> void:
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
	
	map.cursor.set_display_on_empty_cell(true)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_map_generation_finished() -> void:
	renderer.init_rendering_queue(map.get_layers_array())
