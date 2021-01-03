extends Node2D

const TILE_SIZE = Vector2(32, 32)
const CELL_SIZE = Vector2(32, 16)
const TRANSPARENCY : float = 0.27

const COLOR_SCHEME = {
	"visible" : Color.white,
	"barely_visible": Color.lightgray,
	"not_visible" : Color.darkgray
}

var layers_array : Array = [] setget set_layers_array
var cells_array : Array = []

var rendering_queue : Array = []
var visible_cells := PoolVector3Array() setget set_visible_cells, get_visible_cells

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
			cells_array.append(Vector3(cell.x, cell.y, i))

func set_visible_cells(value: PoolVector3Array): visible_cells = value
func get_visible_cells() -> PoolVector3Array: return visible_cells

#### BUILT-IN ####

func _ready() -> void:
	var _err = Events.connect("iso_object_cell_changed", self, "on_iso_object_cell_changed")
	_err = Events.connect("iso_object_added", self, "on_iso_object_added")
	_err = Events.connect("iso_object_removed", self, "on_iso_object_removed")


func _process(_delta):
	update()

func _draw():
	for thing in rendering_queue:
		if thing is Vector3:
			draw_cellv(thing)
		else:
			draw_object_part(thing)


#### LOGIC ####

func init_rendering_queue(objects_array: Array):
	rendering_queue = cells_array.duplicate()
	for obj in objects_array:
		var parts_array = scatter_iso_object(obj)
		rendering_queue += parts_array
	update_rendering_queue()


# Update the rendering queue, by recomputing the entire rendering order
# This method has a pretty high performance cost, 
# if only one IsoObject is moving, call reorder_iso_obj_in_queue instead
func update_rendering_queue():
	rendering_queue.sort_custom(self, "xyz_sum_compare")


# Replace the given obj at the right position in the rendering queue
func add_iso_obj_in_queue(obj: IsoObject):
	var parts_array = scatter_iso_object(obj)
	
	for part in parts_array:
		for i in range(rendering_queue.size()):
			if xyz_sum_compare(part, rendering_queue[i]):
				rendering_queue.insert(i, part)
				break


# Adds every obj contained in the given array in the rendering queue by 
# scattering them in render parts
func add_iso_obj_in_queue_array(obj_array: Array):
	for obj in obj_array:
		add_iso_obj_in_queue(obj)


# Remove the given object from the rendering queue
func remove_iso_obj_from_queue(obj: IsoObject):
	for elem in rendering_queue:
		if elem is IsoObjectRenderPart && elem.get_object_ref() == obj:
			rendering_queue.erase(elem)


# Replace the given obj at the right position in the rendering queue
func reorder_iso_obj_in_queue(obj: IsoObject):
	remove_iso_obj_from_queue(obj)
	add_iso_obj_in_queue(obj)


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
		modul = COLOR_SCHEME["not_visible"]
	elif is_cell_in_view_field_border(cell3D):
		modul = COLOR_SCHEME["barely_visible"]
	
	### HIGH PERFORMANCE COST ###
	### MIGHT BE UNECCESSARY WITH A SEE THROUGH SHADER ###
	# Handle the tile transparancy
#	for object in focus_array:
#		var focus_cell = object.get_current_cell()
#		var height_dif = (height - focus_cell.z)
#
#		if is_cell_transparent(focus_cell, cell3D, height_dif):
#				modul.a = TRANSPARENCY
	
	# Get the tile id and the position of the cell in the autotile
	var tile_id = ground.get_cellv(cell)
	var tile_tileset_pos = tileset.tile_get_region(tile_id).position
	var autotile_coord = ground.get_cell_autotile_coord(int(cell.x), int(cell.y))
	
	# Get the texture
	var stream_texture = tileset.tile_get_texture(tile_id)
	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(stream_texture)
	atlas_texture.set_region(Rect2(tile_tileset_pos + (autotile_coord * TILE_SIZE), TILE_SIZE))
	
	# Set the texture to the right position
	var world_height = Vector2(0, -16 * height + 8)
	var centered_offset = (CELL_SIZE / 2 * is_centered)
	var pos = ground.map_to_world(cell) + world_height - centered_offset
	
	# Draw the texture
	draw_texture(atlas_texture, pos, modul)


# Draw the given object part
# MIGHT BE OPTIMIZED BY COMPLETELY REMOVE USAGE OF THE ORIGIN OBJECT
# LESS REFERENCE CALL AND BETTER DATA CONTIGUITY
func draw_object_part(part: IsoObjectRenderPart):
#	var cell = part.get_current_cell()
#	var a : float = 1.0
	var obj = part.get_object_ref()
	var mod = part.get_modulate()
	var is_visible : bool = obj.is_currently_visible() or obj is TileArea
	var texture = part.get_atlas_texture()
	var obj_pos = obj.get_global_position()
	var part_offset = part.get_texture_offset()
	
	if !is_visible:
		if obj is Enemy:
			mod = Color.transparent
		else:
			mod = Color.darkgray
	
#	# Handle the object transparancy
#	for focus_object in focus_array:
#		var focus_cell = focus_object.get_current_cell()
#		var height_dif = (height - focus_cell.z)
#
#		if obj in focus_array or obj is TileArea:
#			continue
#
#		if is_cell_transparent(focus_cell, cell, height_dif):
#			a = TRANSPARENCY
	
#	# Draw the composing elements of the object
#	for child in obj.get_children():
#		if child is Sprite:
#			draw_sprite(child, a, mod)
	
	draw_texture(texture, obj_pos + part_offset, mod)


# Scatters a texture in the given number of smaller height, then returns it in an array
## ONLY HANDLE VERTICAL SCATTERING - MULTIPLE TILES WIDE OBJECTS ARE NOT SUPPORTED ##
func scatter_iso_object(obj: IsoObject) -> Array:
	var scattered_obj : Array = []
	
	#### NEED TO BE DYNAMIC ####
	var sprite = obj.get_node("Sprite")
	var texture = sprite.get_texture()
	
	var height = obj.get_height()
	var obj_cell = obj.get_current_cell()
	var texture_size = texture.get_size()
	
	var sprite_centered = sprite.is_centered()
	var sprite_pos = sprite.get_position()
	
	#### THIS NEED TO TAKE ALPHA IN ACOUNT ####
	var mod = sprite.get_modulate().blend(obj.get_modulate())
	
	var part_size = Vector2(texture_size.x, texture_size.y / height)
	for i in range(height):
		var part_texture = AtlasTexture.new()
		part_texture.set_atlas(texture)
		part_texture.set_region(Rect2(Vector2(0, part_size.y * i), part_size))
		
		var height_offset = Vector2(0, -part_size.y * height - i - 1)
		var centered_offset = (Vector2(-texture_size.x, texture_size.y) / 2) * int(sprite_centered)
		var offset = height_offset + sprite_pos + centered_offset
		
		var part_cell = obj_cell + Vector3(0, 0, height - i)
		
		var part = IsoObjectRenderPart.new(obj, part_texture, part_cell, offset, mod)
		scattered_obj.append(part)
	return scattered_obj


# Draw the given sprite
func draw_sprite(sprite : Sprite, a : float = 1.0, obj_modul = Color.white):
	var modul = sprite.get_modulate()
	var region_rect = sprite.get_rect()
	var is_region_enabled = sprite.is_region()
	
	if obj_modul in [Color.darkgray, Color.transparent]:
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


# Check if the given object have at least one part of it in the rendering queue
func is_obj_in_rendering_queue(obj: IsoObject):
	for elem in rendering_queue:
		if elem is IsoObjectRenderPart && elem.get_object_ref() == obj:
			return true
	return false 


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
	
	if upper_left_cell in rendering_queue:
		return false
	
	return cell.z == focus_cell.z + 1 && \
		cell.x == focus_cell.x + 1 && \
		cell.y == focus_cell.y + 2 && \
		right_down_cell in rendering_queue


func is_cell_in_dead_angle_left(focus_cell: Vector3, cell: Vector3) -> bool:
	var upper_right_cell = Vector3(focus_cell.x + 1, focus_cell.y, focus_cell.z + 1)
	var left_down_cell = Vector3(focus_cell.x, focus_cell.y + 1, focus_cell.z + 1)
	
	if upper_right_cell in rendering_queue:
		return false
	
	return cell.z == focus_cell.z + 1 && \
		cell.y == focus_cell.y + 1 && \
		cell.x == focus_cell.x + 2 && \
		left_down_cell in rendering_queue


# Returns true if the given cell is a the border of the view field
# Meanings it has at least one non visible adjacent tile
func is_cell_in_view_field_border(cell: Vector3) -> bool:
	var adjacents = Map.get_adjacent_cells(cell)
	for adj_cell in adjacents:
		if Map.find_2D_cell(adj_cell, visible_cells) == Vector3.INF:
			return true
	return false


# Compare two positions, return true if a must be renderer before b
func xyz_sum_compare(a, b) -> bool:
	var grid_pos_a = a if a is Vector3 else a.get_current_cell()
	var grid_pos_b = b if b is Vector3 else b.get_current_cell()
	
	var sum_a = grid_pos_a.x + grid_pos_a.y + grid_pos_a.z
	var sum_b = grid_pos_b.x + grid_pos_b.y + grid_pos_b.z

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

func on_iso_object_cell_changed(obj: IsoObject):
	if is_obj_in_rendering_queue(obj):
		reorder_iso_obj_in_queue(obj)
	else:
		add_iso_obj_in_queue(obj)

func on_iso_object_added(obj: IsoObject):
	add_iso_obj_in_queue(obj)

func on_iso_object_removed(obj: IsoObject):
	remove_iso_obj_from_queue(obj)
