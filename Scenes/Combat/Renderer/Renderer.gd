extends Node2D

const tile_size = Vector2(32, 32)
const cell_size = Vector2(32, 16)

const transparency : float = 0.27

var layers_array : Array = [] setget set_layers_array
var objects_array : Array = [] setget set_objects_array
var ground_cells_array : Array = []

var sorting_array : Array = []
var visible_cells := PoolVector3Array()

var focus_array : Array = [] setget set_focus_array, get_focus_array

enum type_priority {
	TILE,
	AREA,
	CURSOR,
	OBSTACLE,
	ACTOR
}

#### ACCESSORS ####

func set_focus_array(array: Array): focus_array = array
func get_focus_array() -> Array: return focus_array

func set_layers_array(array: Array):
	layers_array = array
	for i in range(layers_array.size()):
		for cell in layers_array[i].get_used_cells():
			ground_cells_array.append(Vector3(cell.x, cell.y, i))


func set_objects_array(array: Array):
	objects_array = array


#### BUILT-IN ####

func _ready() -> void:
	var _err = Events.connect("visible_cells_changed", self, "_on_visible_cells_changed")

func _process(_delta):
	update()

func _draw():
	sorting_array = ground_cells_array + objects_array

	sorting_array.sort_custom(self, "xyz_sum_compare")
	for thing in sorting_array:
		if thing is Vector3:
			draw_cellv(thing)
		else:
			draw_object(thing)


#### LOGIC ####


# Draw a single given cell
func draw_cellv(cell3D: Vector3):
	var ground = layers_array[cell3D.z]
	var tileset = ground.get_tileset()
	var cell = Vector2(cell3D.x, cell3D.y)
	
	draw_tile(ground, tileset, cell, int(cell3D.z))


# Draw the given tile from the given tilemap
func draw_tile(ground: TileMap, tileset: TileSet, cell: Vector2, height: int):
	if !(cell in ground.get_used_cells()):
		return
	
	var is_centered : int = ground.get_tile_origin()
	var modul : Color = ground.get_modulate()
	
	var cell3D = Vector3(cell.x, cell.y, height)
	if not cell3D in visible_cells:
		modul = Color.gray
	
	# Handle the tile transparancy
	for object in focus_array:
		var focus_cell = object.get_current_cell()
		var height_dif = (height - focus_cell.z)
		
		if is_cell_transparent(focus_cell, cell3D, height_dif):
				modul.a = transparency
	
	# Get the tile id and the position of the cell in the autotile
	var tile_id = ground.get_cellv(cell)
	var tile_tileset_pos = tileset.tile_get_region(tile_id).position
	var autotile_coord = ground.get_cell_autotile_coord(int(cell.x), int(cell.y))
	
	# Get the texture
	var stream_texture = tileset.tile_get_texture(tile_id)
	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(stream_texture)
	atlas_texture.set_region(Rect2(tile_tileset_pos + (autotile_coord * tile_size), tile_size))
	
	# Set the texture to the right position
	var world_height = Vector2(0, -16 * height + 8)
	var centered_offset = (cell_size / 2 * is_centered)
	var pos = ground.map_to_world(cell) + world_height - centered_offset
	
	# Draw the texture
	draw_texture(atlas_texture, pos, modul)


# Draw the given object
func draw_object(obj: IsoObject):
	var height = obj.get_height()
	var cell = obj.get_current_cell()
	var a : float = 1.0
	var mod = obj.get_modulate()
	var is_visible : bool = cell in visible_cells or obj is TileArea
	
	if !is_visible:
		if obj is Enemy:
			mod = Color.transparent
		else:
			mod = Color.gray
	
	# Handle the object transparancy
	for focus_object in focus_array:
		var focus_cell = focus_object.get_current_cell()
		var height_dif = (height - focus_cell.z)
		
		if obj in focus_array or obj is TileArea:
			continue
		
		if is_cell_transparent(focus_cell, cell, height_dif):
			a = transparency
	
	# Draw the composing elements of the object
	for child in obj.get_children():
		if child is Sprite:
			draw_sprite(child, a, mod)


# Draw the given sprite
func draw_sprite(sprite : Sprite, a : float = 1.0, obj_modul = Color.white):
	var modul = sprite.get_modulate()
	var region_rect = sprite.get_rect()
	var is_region_enabled = sprite.is_region()
	
	if obj_modul in [Color.gray, Color.transparent]:
		modul = obj_modul
	else:
		if obj_modul != Color.white:
			modul = modul.blend(obj_modul)
	
	if a < modul.a:
		modul.a = a
	
	var texture = sprite.get_texture()
	var sprite_centered = sprite.is_centered()
	var sprite_pos = sprite.get_global_position()
	var pos = sprite_pos - (texture.get_size() / 2) * int(sprite_centered)
	
	if is_region_enabled:
		### INVESTIGATE THIS WEIRD x-axis 16 PIXELS OFFSET ###
		draw_texture_rect_region(texture, Rect2(pos + Vector2(16, 0), region_rect.size), 
					Rect2(Vector2.ZERO, region_rect.size), modul)
	else:
		draw_texture(texture, pos, modul)


#### NOT WORKING FOR NOW, LABELS ARE RENDERED BY THE ENGINE ####
# Draw the given label
func draw_label(label: Label):
	var font = label.get_theme().get_default_font()
	var pos = label.get_rect().position
	var text = label.text
	for i in range(text.length()):
		var i_max = i + 1
		var next
		
		if i_max >= text.length(): next = ""
		else: next = text[i_max]
		
		var _err = draw_char(font, pos, text[i], next)


# Draw the whole layer of the given height
func draw_ground_layer(layer_height: int):
	var ground = layers_array[layer_height].get_node("Ground")
	var tileset = ground.get_tileset()
	
	for cell in ground.get_used_cells():
		draw_tile(ground, tileset, cell, layer_height)


# Return the value of the drawing priority of the given object type
func get_type_priority(thing) -> int:
	if thing is Vector3:
		return type_priority.TILE
	elif thing is TileArea:
		return type_priority.AREA
	elif thing is Cursor:
		return type_priority.CURSOR
	elif thing is Obstacle:
		return type_priority.OBSTACLE
	elif thing is Actor:
		return type_priority.ACTOR
	
	return -1


# Return true if the given cell should be transparent
func is_cell_transparent(focus_cell: Vector3, cell: Vector3, height_dif : int) -> bool :
	if (is_cell_in_front(focus_cell, cell) and \
	is_cell_close_enough(focus_cell, cell, height_dif)) or \
	(is_cell_in_dead_angle_left(focus_cell, cell) or \
	is_cell_in_dead_angle_right(focus_cell, cell)):
		if cell != focus_cell:
			return true
	return false


func is_cell_close_enough(focus_cell: Vector3, cell: Vector3, height_dif : int) -> bool:
	return abs(cell.x - focus_cell.x) <= height_dif && abs(cell.y - focus_cell.y) <= height_dif


func is_cell_in_front(focus_cell: Vector3, cell: Vector3) -> bool:
	return cell.x > focus_cell.x - 1 && cell.y > focus_cell.y - 1


func is_cell_in_dead_angle_right(focus_cell: Vector3, cell: Vector3) -> bool:
	var upper_left_cell = Vector3(focus_cell.x, focus_cell.y + 1, focus_cell.z + 1)
	var right_down_cell = Vector3(focus_cell.x + 1, focus_cell.y, focus_cell.z + 1)
	
	if upper_left_cell in sorting_array:
		return false
	
	return cell.z == focus_cell.z + 1 && \
		cell.x == focus_cell.x + 1 && \
		cell.y == focus_cell.y + 2 && \
		right_down_cell in sorting_array


func is_cell_in_dead_angle_left(focus_cell: Vector3, cell: Vector3) -> bool:
	var upper_right_cell = Vector3(focus_cell.x + 1, focus_cell.y, focus_cell.z + 1)
	var left_down_cell = Vector3(focus_cell.x, focus_cell.y + 1, focus_cell.z + 1)
	
	if upper_right_cell in sorting_array:
		return false
	
	return cell.z == focus_cell.z + 1 && \
		cell.y == focus_cell.y + 1 && \
		cell.x == focus_cell.x + 2 && \
		left_down_cell in sorting_array


# Compare two positions, return true if a must be renderer before b
func xyz_sum_compare(a, b) -> bool:
	var grid_pos_a
	var height_a
	if a is Vector3:
		grid_pos_a = a
		height_a = 1
	else:
		grid_pos_a = a.get_current_cell()
		height_a = a.get_height()
	
	var grid_pos_b
	var height_b
	if b is Vector3:
		grid_pos_b = b
		height_b = 1
	else:
		grid_pos_b = b.get_current_cell()
		height_b = b.get_height()
	
	var sum_a = grid_pos_a.x + grid_pos_a.y + grid_pos_a.z + height_a
	var sum_b = grid_pos_b.x + grid_pos_b.y + grid_pos_b.z + height_b

	# First compare the sum x + y + z + heigth
	# Then compare y, then x, then z
	# If nothing worked, sort by type
	if sum_a == sum_b:
		if grid_pos_a.y == grid_pos_b.y:
			if grid_pos_a.x == grid_pos_b.x:
				if grid_pos_a.z == grid_pos_b.z:
					return get_type_priority(a) < get_type_priority(b)
				else:
					return grid_pos_a.z < grid_pos_b.z
			else:
				return grid_pos_a.x < grid_pos_b.x
		else:
			return grid_pos_a.y < grid_pos_b.y
	else:
		return sum_a < sum_b


#### SIGNAL RESPONSES ####

func _on_visible_cells_changed():
	var allies_array = get_tree().get_nodes_in_group("Allies")
	visible_cells = []
	for ally in allies_array:
		for cell in ally.view_field:
			if not cell in visible_cells:
				visible_cells.append(cell)
