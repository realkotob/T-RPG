extends Node2D
class_name MapEditor

enum PLACEMENT_TYPE{
	TILE,
	LINE,
	RECT,
	ARRAY
}

onready var renderer = $Renderer
onready var tile_list = $UI/TileList

export var map_scene_path : String = ""
export var print_logs : bool = false

var map : IsoMap = null
var undo_redo = UndoRedo.new()

var selected_tile_id : int = -1 setget set_selected_tile_id, get_selected_tile_id
var last_cell_clicked = Vector3.INF

var tracked_tiles = []

class Tile:
	var cell =  Vector2.INF
	var tile_id : int = -1
	
	func _init(_cell: Vector3, _tile_id: int) -> void:
		cell = _cell
		tile_id = _tile_id

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


func _place_procedure(placement_type: int, tile_id: int = selected_tile_id) -> void:
	var do_method = ""
	var do_args = []
	var cursor_cell = map.cursor.get_current_cell()
	
	if placement_type != PLACEMENT_TYPE.ARRAY:
		tracked_tiles = []
	
	match(placement_type):
		PLACEMENT_TYPE.TILE:
			do_method = "_place_tile"
			do_args = [cursor_cell, tile_id]
			
		PLACEMENT_TYPE.LINE:
			do_method = "_place_tile_line"
			do_args = [last_cell_clicked, cursor_cell, tile_id]
			
		PLACEMENT_TYPE.RECT:
			do_method = "_place_tile_rect"
			do_args = [last_cell_clicked, cursor_cell, tile_id]
			
		PLACEMENT_TYPE.ARRAY:
			do_method = "_place_tiles_array"
			var placement_cells = []
			
			for tile in tracked_tiles:
				placement_cells.append(Tile.new(tile.cell, tile_id))
			
			do_args.append(placement_cells)
	
	tracked_tiles += _track_cells(cursor_cell, placement_type)
	
	var action_name = do_method.capitalize()
	undo_redo.create_action(action_name)
	undo_redo.add_do_method(self, "callv", do_method, do_args)
	undo_redo.add_undo_method(self, "call", "_place_tiles_array", tracked_tiles.duplicate())
	undo_redo.commit_action()
	tracked_tiles = []
	
	if print_logs:
		print("Do: %s" % action_name)


func _place_tiles_array(tile_array: Array) -> void:
	if tile_array.empty():
		return
	
	var tilemap = map.get_layer(tile_array[0].cell.z)
	tilemap.set_cell_array(tile_array)


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
	var rect = _get_cell_rect(from, to)
	
	if !ghost:
		last_cell_clicked = to
	
	var tilemap = map.get_layer(from.z) if !ghost else map.get_layer(from.z).get_node("Ghost")
	
	tilemap.set_rect_cell(rect, tile_id)


func _get_tile_type_tilemap(layer: IsoMapLayer, tile_type: int) -> Node:
	match(tile_type):
		tile_list.TILE_TYPE.DECORATION: return layer.get_node("Decortion")
	return layer


func _get_cell_rect(from: Vector3, to: Vector3) -> Rect2:
	var top_left = Vector2(min(from.x, to.x), min(from.y, to.y))
	var bottom_right = Vector2(max(from.x, to.x), max(from.y, to.y))
	var rect_size = bottom_right - top_left
	return Rect2(top_left, rect_size)


func _track_cells(cursor_cell: Vector3, placement_type: int) -> Array:
	var layer = map.get_layer(cursor_cell.z)
	var tile_type = map.tileset.tile_get_z_index(selected_tile_id)
	var current_tilemap = _get_tile_type_tilemap(layer, tile_type)
	
	var output_array = []
	
	match(placement_type):
		PLACEMENT_TYPE.TILE: 
			var tile_id = current_tilemap.get_cellv(Utils.vec2_from_vec3(cursor_cell))
			output_array.append(Tile.new(cursor_cell, tile_id))
		PLACEMENT_TYPE.LINE:
			for cell in IsoRaycast.bresenham3D(last_cell_clicked, cursor_cell):
				var tile_id = current_tilemap.get_cellv(Utils.vec2_from_vec3(cursor_cell))
				output_array.append(Tile.new(cell, tile_id))
		PLACEMENT_TYPE.RECT:
			var rect = _get_cell_rect(last_cell_clicked, cursor_cell)
			for i in range(rect.size.y + 1):
				for j in range(rect.size.x + 1):
					var cell = Utils.vec2_to_vec3(rect.position + Vector2(j, i), cursor_cell.z)
					var tile_id = current_tilemap.get_cellv(Utils.vec2_from_vec3(cell))
					output_array.append(Tile.new(cell, tile_id))
	
	return output_array


func _is_cell_tracked(cell: Vector3) -> bool:
	for tile in tracked_tiles:
		if tile.cell == cell:
			return true
	return false


func _clear_ghosts() -> void:
	if !is_instance_valid(map):
		return
	
	for layer in map.get_layers_array():
		layer.get_node("Ghost").clear()


#### INPUTS ####

func _unhandled_input(event: InputEvent) -> void:
	if !is_instance_valid(map):
		return
	
	if Input.is_action_just_pressed("z") && event.get_control():
		if print_logs:
			print("Undo: %s" % undo_redo.get_current_action_name())
		undo_redo.undo()
	
	elif Input.is_action_just_pressed("click") or Input.is_action_just_pressed("right_click"):
		var tile_id = selected_tile_id if Input.is_mouse_button_pressed(BUTTON_LEFT) else -1
		
		if Input.is_action_pressed("shift"):
			if last_cell_clicked != Vector3.INF:
				if Input.is_action_pressed("ctrl"):
					_place_procedure(PLACEMENT_TYPE.RECT, tile_id)
				else:
					_place_procedure(PLACEMENT_TYPE.LINE, tile_id)
		else:
			var cursor_cell = map.cursor.get_current_cell()
			var tile_type = map.tileset.tile_get_z_index(selected_tile_id)
			var tilemap = _get_tile_type_tilemap(map.get_layer(cursor_cell.z), tile_type)
			
			if tilemap.get_cellv(Utils.vec2_from_vec3(cursor_cell)) != tile_id:
				_place_procedure(PLACEMENT_TYPE.TILE, tile_id)
	
	elif undo_redo.get_current_action_name() == "Place Tile":
		if !Input.is_action_pressed("ctrl") && !Input.is_action_pressed("shift") && tracked_tiles.size() > 1:
			
			if Input.is_action_just_released("click"):
				_place_procedure(PLACEMENT_TYPE.ARRAY)
				_clear_ghosts()
			
			elif Input.is_action_just_released("right_click"):
				_place_procedure(PLACEMENT_TYPE.ARRAY, -1)
				_clear_ghosts()

#### SIGNAL RESPONSES ####


func _on_map_generation_finished() -> void:
	renderer.init_rendering_queue(map.get_layers_array())
	tile_list.update_tile_list(map)


func _on_tile_list_tile_selected(tile_id: int) -> void:
	set_selected_tile_id(tile_id)


func _on_cursor_cell_changed(from: Vector3, to: Vector3) -> void:
	if from == to or selected_tile_id == -1:
		return
	
	# Change the cursor's color based on its location
	var layer = map.get_layer(to.z)
	var cursor_cell = map.cursor.get_current_cell()
	var cursor_tilemap = _get_tile_type_tilemap(layer, selected_tile_id)
	
	if cursor_tilemap.get_cellv(Utils.vec2_from_vec3(cursor_cell)) == -1:
		map.cursor.set_modulate(map.cursor.default_color)
	else:
		map.cursor.set_modulate(Color.deepskyblue)
	
	# Clear the ghost tilemap for update
	var ghost_tilemap : TileMap = layer.get_node("Ghost")
	ghost_tilemap.clear()
	
	# Moving while clicking
	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if !_is_cell_tracked(from):
			tracked_tiles += _track_cells(from, PLACEMENT_TYPE.TILE)

		if !_is_cell_tracked(to):
			tracked_tiles += _track_cells(to, PLACEMENT_TYPE.TILE)
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			_place_tile(to, selected_tile_id)
		
		elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
			_place_tile(to, -1)
	
	# Ghost tiles
	else:
		if Input.is_action_pressed("shift"):
			if last_cell_clicked != Vector3.INF:
				if Input.is_action_pressed("ctrl"):
					_place_tile_rect(last_cell_clicked, to, selected_tile_id, true)
				else:
					_place_tile_line(last_cell_clicked, to, selected_tile_id, true)
		else:
			_place_tile(to, selected_tile_id, true)
