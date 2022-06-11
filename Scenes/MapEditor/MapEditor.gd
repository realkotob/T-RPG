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
onready var notification_list = $UI/NotificationList
onready var save_menu = $UI/SaveMenu

export var map_scene_path : String = ""
export var print_logs : bool = false

export var max_z : int = 15

export var last_map_path : String = ""

var dest_path : String = ""

var map : IsoMap = null setget set_map, get_map
var undo_redo = UndoRedo.new()

var selected_tile_id : int = -1 setget set_selected_tile_id, get_selected_tile_id
var last_cell_clicked = Vector3.INF

var tracked_tiles = []

export var ignore_ghosts : bool = false

signal map_changed

class Tile:
	var cell := Vector3.INF
	var tile_id : int = -1
	
	func _init(_cell: Vector3, _tile_id: int) -> void:
		cell = _cell
		tile_id = _tile_id

#### ACCESSORS ####

func is_class(value: String): return value == "MapEditor" or .is_class(value)
func get_class() -> String: return "MapEditor"

func set_selected_tile_id(value: int): selected_tile_id = value
func get_selected_tile_id() -> int: return selected_tile_id

func set_map(value: IsoMap): 
	if value != map:
		map = value
		emit_signal("map_changed", map)
func get_map() -> IsoMap: return map

#### BUILT-IN ####

func _ready() -> void:
	var __ = tile_list.connect("tile_selected", self, "_on_tile_list_tile_selected")
	__ = connect("map_changed", self, "_on_map_changed")
	__ = save_menu.connect("save_map", self, "_on_save_menu_save_query")
	__ = save_menu.connect("load_map", self, "_on_save_menu_load_query")
	__ = save_menu.connect("load_last_map", self, "_on_save_menu_load_last_map_query")
	
	if map_scene_path != "" && DirNavHelper.is_file_existing(map_scene_path):
		_change_map(map_scene_path)


#### VIRTUALS ####


#### LOGIC ####


func _change_map(map_path: String) -> void:
	if DirNavHelper.is_file_existing(map_path):
		map_scene_path = map_path
	
	var map_scene = ResourceLoader.load(map_scene_path, "PackedScene")
	var map_instance = map_scene.instance()
	
	if not map_instance is IsoMap:
		push_error("The given .tscn at path %s doesn't contain an IsoMap" % map_path)
		return
	
	# Update the last_map_path, then save the editor scene in file to make the data persist
	last_map_path = map_path
	var editor_scene = PackedScene.new()
	editor_scene.pack(self)
	
	if ResourceSaver.save(filename, editor_scene) != OK:
		push_error("Overwriting map_editor scene failed")
	
	# Ask the user if they want to save the file
	if is_instance_valid(map):
		map.queue_free()
		renderer.clear()
	
	set_map(map_instance)
	var __ = map.connect("map_generation_finished", self, "_on_map_generation_finished")
	
	add_child(map)
	map.set_owner(self)
	
	__ = map.cursor.connect("cell_changed", self, "_on_cursor_cell_changed")
	map.cursor.set_display_on_empty_cell(true)


func _place_procedure(placement_type: int, tile_id: int = selected_tile_id, layer_range: Array = [0]) -> void:
	var do_method = ""
	var do_args = []
	var cursor_cell = map.cursor.get_current_cell()
	
	if placement_type != PLACEMENT_TYPE.ARRAY:
		tracked_tiles = []
	
	match(placement_type):
		PLACEMENT_TYPE.TILE:
			do_method = "_place_tile"
			do_args = [cursor_cell, tile_id, false,  layer_range]
		
		PLACEMENT_TYPE.LINE:
			do_method = "_place_tile_line"
			do_args = [last_cell_clicked, cursor_cell, tile_id, false,  layer_range]
		
		PLACEMENT_TYPE.RECT:
			do_method = "_place_tile_rect"
			do_args = [last_cell_clicked, cursor_cell, tile_id, false, layer_range]
		
		PLACEMENT_TYPE.ARRAY:
			do_method = "_place_tiles_array"
			var placement_cells = []
			
			for tile in tracked_tiles:
				placement_cells.append(Tile.new(tile.cell, tile_id))
			
			do_args = [placement_cells, layer_range]
	
	tracked_tiles += _track_cells(cursor_cell, placement_type)
	
	var action_name = do_method.capitalize()
	undo_redo.create_action(action_name)
	undo_redo.add_do_method(self, "callv", do_method, do_args)
	undo_redo.add_undo_method(self, "call", "_place_tiles_array", tracked_tiles.duplicate(), layer_range)
	undo_redo.commit_action()
	tracked_tiles = []
	
	notification_list.push_notification("Do: %s" % action_name)


func _place_tiles_array(tile_array: Array, layer_range: Array = [0]) -> void:
	if tile_array.empty():
		return
	
	for layer_id in layer_range:
		var layer = map.get_layer(layer_id)
		layer.set_cell_array(tile_array)


func _place_tile(cell: Vector3, tile_id: int = selected_tile_id, ghost: bool = false, layer_range: Array = [0]) -> void:
	if !ghost:
		last_cell_clicked = cell
	
	for layer_id in layer_range:
		var cell2d = Vector2(cell.x, cell.y)
		
		var tilemap = map.get_layer(layer_id) if !ghost else map.get_layer(layer_id).get_node("Ghost")
		var tile_type = _get_tile_type(selected_tile_id)
		
		if ghost:
			tilemap.set_cellv(cell2d, tile_id)
		else:
			tilemap.place_tile(cell2d, tile_id, tile_type)


func _place_tile_line(origin: Vector3, dest: Vector3, tile_id: int = selected_tile_id, ghost: bool = false, layer_range: Array = [0]) -> void:
	if !ghost:
		last_cell_clicked = dest
	
	var line = IsoRaycast.bresenham3D(origin, dest)
	
	for layer_id in layer_range:
		var tilemap = map.get_layer(layer_id) if !ghost else map.get_layer(layer_id).get_node("Ghost")
		for cell in line:
			tilemap.set_cell(int(cell.x), int(cell.y), tile_id)


func _place_tile_rect(from: Vector3, to: Vector3, tile_id : int = selected_tile_id, ghost: bool = false, layer_range: Array = [0]) -> void:
	var rect = _get_cell_rect(from, to)
	
	if !ghost:
		last_cell_clicked = to
	
	for layer_id in layer_range:
		var tilemap = map.get_layer(layer_id) if !ghost else map.get_layer(layer_id).get_node("Ghost")
		
		tilemap.set_rect_cell(rect, tile_id)


func _get_tile_type_tilemap(layer: IsoMapLayer, tile_type: int) -> Node:
	match(tile_type):
		GAME.TILE_TYPE.DECORATION: return layer.get_node("Decortion")
	return layer


func _get_cell_rect(from: Vector3, to: Vector3) -> Rect2:
	var top_left = Vector2(min(from.x, to.x), min(from.y, to.y))
	var bottom_right = Vector2(max(from.x, to.x), max(from.y, to.y))
	var rect_size = bottom_right - top_left
	return Rect2(top_left, rect_size)


func _track_cells(cursor_cell: Vector3, placement_type: int) -> Array:
	var layer = map.get_layer(cursor_cell.z)
	var tile_type = _get_tile_type(selected_tile_id)
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


func _compute_layer_range(cursor_cell: Vector3) -> Array:
	return [cursor_cell.z] if !Input.is_action_pressed("alt") else range(int(cursor_cell.z + 1))


func _paint_bucket(cell: Vector3, tile_id: int) -> void:
	var layer = map.get_layer(cell.z)
	var current_tile_id = layer.get_cellv(Utils.vec2_from_vec3(cell))
	
	if current_tile_id == -1:
		push_warning("The selected tile's id is -1, ie an empty cell")
		return
	
	var cells = []
	map.get_same_adjacent_tiles(cell, current_tile_id, cells)
	
	tracked_tiles = []
	for cell in cells:
		tracked_tiles.append(Tile.new(cell, current_tile_id))
	
	_place_procedure(PLACEMENT_TYPE.ARRAY, tile_id)


func _save_map(save_path: String = "") -> void:
	if !is_instance_valid(map):
		return
	
	if save_path == "":
		save_path = map_scene_path
	
	map.cursor.set_z_locked(false)
	_clear_ghosts()
	
	var map_scene = PackedScene.new()
	map_scene.pack(map)
	var err = ResourceSaver.save(save_path, map_scene)
	
	if err == OK:
		notification_list.push_notification("Map saved a path %s" % save_path)
	else:
		push_error("The map couldn't be saved at path %s, error code : %d" % [save_path, err])
	
	map.cursor.set_z_locked(true)


func _get_tile_type(tile_id: int) -> int:
	return map.tileset.tile_get_z_index(tile_id) if tile_id != -1 else -1


#### INPUTS ####

func _unhandled_input(event: InputEvent) -> void:
	if !is_instance_valid(map):
		return
	
	var cursor = map.cursor
	var tile_id = selected_tile_id if Input.is_mouse_button_pressed(BUTTON_LEFT) else -1
	var cursor_cell = cursor.get_current_cell()
	var layer_range = _compute_layer_range(cursor_cell)
	
	# Handles Undo/Redo
	if Input.is_action_just_pressed("z") && event.get_control():
		if event.get_shift():
			undo_redo.redo()
			notification_list.push_notification("Redo: %s" % undo_redo.get_current_action_name())
		else:
			notification_list.push_notification("Undo: %s" % undo_redo.get_current_action_name())
			undo_redo.undo()
	
	# Handles quick save
	elif Input.is_action_pressed("ctrl") && Input.is_action_just_pressed("s"):
		_save_map()
	
	# Handles placing the cursor at the closest cell form the user at mouse position 
	elif Input.is_action_just_pressed("click") && event.get_control() && !event.get_shift() && !event.get_alt():
		cursor.place_at_world_pos(get_global_mouse_position())
	
	# Handles adding/removing tiles
	elif Input.is_action_just_pressed("click") or Input.is_action_just_pressed("right_click"):
		
		if Input.is_action_pressed("shift"):
			if last_cell_clicked != Vector3.INF:
				if Input.is_action_pressed("ctrl"):
					_place_procedure(PLACEMENT_TYPE.RECT, tile_id, layer_range)
				else:
					_place_procedure(PLACEMENT_TYPE.LINE, tile_id, layer_range)
		
		# Paint bucket
		elif Input.is_key_pressed(KEY_G):
			_paint_bucket(cursor_cell, tile_id)
		
		else:
			var tile_type = _get_tile_type(selected_tile_id)
			var tilemap = _get_tile_type_tilemap(map.get_layer(cursor_cell.z), tile_type)
			
			_place_procedure(PLACEMENT_TYPE.TILE, tile_id, layer_range)
	
	# Handles moving on the z axis
	elif event is InputEventMouseButton && event.button_index in [BUTTON_WHEEL_DOWN, BUTTON_WHEEL_UP]:
		if !event.is_pressed():
			return
		
		var movement = Vector3(0, 0, -1) if event.button_index == BUTTON_WHEEL_DOWN else Vector3(0, 0, 1)
		var future_cell = cursor_cell + movement
		
		if future_cell.z < 0 or future_cell.z > max_z:
			return
		
		var layer = map.get_layer(future_cell.z)
		if layer == null:
			map.add_layer(future_cell.z)
			yield(map, "layer_added")
		
		cursor.set_z_cell_offset(cursor.get_z_cell_offset() + movement.z)
		cursor.set_current_cell(future_cell)
	
	# Handles placing multiple tiles in one click
	elif undo_redo.get_current_action_name() == "Place Tile":
		if !Input.is_action_pressed("ctrl") && !Input.is_action_pressed("shift") && tracked_tiles.size() > 1:
			
			if Input.is_action_just_released("click"):
				_place_procedure(PLACEMENT_TYPE.ARRAY, selected_tile_id, layer_range)
				_clear_ghosts()
			
			elif Input.is_action_just_released("right_click"):
				_place_procedure(PLACEMENT_TYPE.ARRAY, -1, layer_range)
				_clear_ghosts()


#### SIGNAL RESPONSES ####


func _on_map_changed(new_map: IsoMap) -> void:
	save_menu.set_visible(new_map != null)
	tile_list.set_visible(new_map != null)


func _on_map_generation_finished() -> void:
	renderer.init_rendering_queue(map.get_layers_array())
	tile_list.update_tile_list(map)
	map.cursor.set_z_locked(true)


func _on_tile_list_tile_selected(tile_id: int) -> void:
	set_selected_tile_id(tile_id)


func _on_cursor_cell_changed(from: Vector3, to: Vector3) -> void:
	if from == to or !is_instance_valid(map):
		return
	
	# Change the cursor's color based on its location
	var layer = map.get_layer(to.z)
	var cursor_cell = map.cursor.get_current_cell()
	var cursor_tilemap = _get_tile_type_tilemap(layer, selected_tile_id)
	var layer_range = _compute_layer_range(cursor_cell)
	
	if cursor_tilemap.get_cellv(Utils.vec2_from_vec3(cursor_cell)) == -1:
		map.cursor.set_modulate(map.cursor.default_color)
	else:
		map.cursor.set_modulate(Color.deepskyblue)
	
	# Clear the ghost tilemap for update
	_clear_ghosts()
	
	# Moving while clicking
	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if Input.is_action_pressed("shift") or Input.is_action_pressed("ctrl"):
			return
		
		if !_is_cell_tracked(from):
			tracked_tiles += _track_cells(from, PLACEMENT_TYPE.TILE)

		if !_is_cell_tracked(to):
			tracked_tiles += _track_cells(to, PLACEMENT_TYPE.TILE)
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			_place_tile(to, selected_tile_id, false, layer_range)

		elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
			_place_tile(to, -1, false, layer_range)
	
	# Ghost tiles
	else:
		if !ignore_ghosts:
			if Input.is_action_pressed("shift"):
				if last_cell_clicked != Vector3.INF:
					if Input.is_action_pressed("ctrl"):
						_place_tile_rect(last_cell_clicked, to, selected_tile_id, true, layer_range)
					else:
						_place_tile_line(last_cell_clicked, to, selected_tile_id, true, layer_range)
			else:
				_place_tile(to, selected_tile_id, true, layer_range)


func _on_save_menu_save_query(path: String) -> void:
	if path != "":
		dest_path = path
	_save_map(dest_path)


func _on_save_menu_load_query(path: String) -> void:
	_change_map(path)


func _on_save_menu_load_last_map_query() -> void:
	if last_map_path == "":
		push_error("Can't load last map: no last map path exists")
		return
	
	_change_map(last_map_path)
