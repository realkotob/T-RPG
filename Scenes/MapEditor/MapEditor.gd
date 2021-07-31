extends Node2D
class_name MapEditor

onready var renderer = $Renderer
onready var tile_list = $UI/TileList

export var map_scene_path : String = ""
var map : IsoMap = null

var selected_tile_id : int = -1 setget set_selected_tile_id, get_selected_tile_id

var last_cell_clicked = Vector3.INF

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


func _place_tile(cell: Vector3, tile_id: int = selected_tile_id, ghost: bool = false) -> void:
	if !ghost:
		last_cell_clicked = cell
		
	var cell2d = Vector2(cell.x, cell.y)
	var tile_type = map.tileset.tile_get_z_index(selected_tile_id)
	var tilemap = map.get_layer(cell.z) if !ghost else map.get_layer(cell.z).get_node("Ghost")
	
	if tile_type == tile_list.TILE_TYPE.TILE:
		tilemap.set_cellv(cell2d, tile_id)


func _place_tile_line(origin: Vector3, dest: Vector3, tile_id: int = selected_tile_id, ghost: bool = false) -> void:
	if !ghost:
		last_cell_clicked = dest
	var tilemap = map.get_layer(dest.z) if !ghost else map.get_layer(dest.z).get_node("Ghost")
	var line = IsoRaycast.bresenham3D(origin, dest)
	for cell in line:
		tilemap.set_cell(int(cell.x), int(cell.y), tile_id)


func _place_tile_rect(from: Vector3, to: Vector3, tile_id : int = selected_tile_id, ghost: bool = false) -> void:
	var top_left = Vector2(min(from.x, to.x), min(from.y, to.y))
	var bottom_right = Vector2(max(from.x, to.x), max(from.y, to.y))
	var rect_size = bottom_right - top_left
	var rect = Rect2(top_left, rect_size)
	
	if !ghost:
		last_cell_clicked = from
	
	var tilemap = map.get_layer(from.z) if !ghost else map.get_layer(from.z).get_node("Ghost")
	
	tilemap.set_rect_cell(rect, tile_id)


#### INPUTS ####

func _unhandled_input(_event: InputEvent) -> void:
	if !is_instance_valid(map):
		return
	
	var cursor_cell = map.cursor.get_current_cell()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if Input.is_action_pressed("shift"):
			if last_cell_clicked != Vector3.INF:
				if Input.is_action_pressed("ctrl"):
					_place_tile_rect(last_cell_clicked, cursor_cell, selected_tile_id, false)
				else:
					_place_tile_line(last_cell_clicked, cursor_cell, selected_tile_id, false)
		else:
			_place_tile(cursor_cell, selected_tile_id)
	
	elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if Input.is_action_pressed("shift"):
			if last_cell_clicked != Vector3.INF:
				if Input.is_action_pressed("ctrl"):
					_place_tile_rect(last_cell_clicked, cursor_cell, -1, false)
				else:
					_place_tile_line(last_cell_clicked, cursor_cell, -1, false)
		else:
			_place_tile(cursor_cell, -1)


#### SIGNAL RESPONSES ####


func _on_map_generation_finished() -> void:
	renderer.init_rendering_queue(map.get_layers_array())
	tile_list.update_tile_list(map)


func _on_tile_list_tile_selected(tile_id: int) -> void:
	set_selected_tile_id(tile_id)


func _on_cursor_cell_changed(from: Vector3, to: Vector3) -> void:
	if from == to or selected_tile_id == -1:
		return
	
	var layer = map.get_layer(to.z)
	var ghost_tilemap : TileMap = layer.get_node("Ghost")
	ghost_tilemap.clear()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		_place_tile(to, selected_tile_id)
	elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
		_place_tile(to, -1)
	else:
		if Input.is_action_pressed("shift"):
			if last_cell_clicked != Vector3.INF:
				if Input.is_action_pressed("ctrl"):
					_place_tile_rect(last_cell_clicked, to, selected_tile_id, true)
				else:
					_place_tile_line(last_cell_clicked, to, selected_tile_id, true)
		else:
			_place_tile(to, selected_tile_id, true)
