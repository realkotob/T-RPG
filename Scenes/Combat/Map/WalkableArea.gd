extends IsoTileMap

onready var PathFinding := get_parent()

var walkable_cells : Array

enum{ BLUE_CELL, RED_CELL }

# Find all the walkable cells and store them in the walkable_cells array
func find_walkable_cells(actor_position : Vector2, actor_movements : int) -> void:
	
	walkable_cells = []
	var actor_point = world_to_map(actor_position)
	var relatives : Array
	
	# Clear all the TileMap
	clear()
	
	# For each actor's movement point, get the 
	for i in range(1, actor_movements + 1):
		
		if i == 1:
			relatives = find_relatives_point(actor_point)
		else:
			relatives = find_relatives_array(relatives)
		
		# Check for every points if it is valid, not already treated an if a path exist between the actor's position and it
		for cell in relatives:
			if PathFinding.is_position_valid(cell) == true && walkable_cells.has(cell) == false:
				
				# Get the world position of the current point
				var point_rel_pos = map_to_world(cell)
				
				# Get the lenght of the path between the actor
				var path_len = len(PathFinding.find_path(actor_position, point_rel_pos))
				if path_len > 0 && path_len - 1 <= actor_movements:
					walkable_cells.append(cell)


# Find all the relatives to an array of points, checking if they haven't been treated before, and return it in an array
func find_relatives_array(point_array : Array) -> Array:
	var result_array : Array = []
	
	for point in point_array:
		var point_relative = PoolVector2Array([
		Vector2(point.x + 1, point.y),
		Vector2(point.x - 1, point.y),
		Vector2(point.x, point.y + 1),
		Vector2(point.x, point.y - 1)])
		
		for cell in point_relative:
			if !walkable_cells.has(cell):
				result_array.append(cell)
	
	return result_array


# Find all the relatives to a points, checking if they haven't been treated before, and return it in an array
func find_relatives_point(point: Vector2) -> Array:
	var result_array : Array = []
	
	var point_relative = Array([
	Vector2(point.x + 1, point.y),
	Vector2(point.x - 1, point.y),
	Vector2(point.x, point.y + 1),
	Vector2(point.x, point.y - 1)])
	
	for cell in point_relative:
		
		if !walkable_cells.has(cell):
			result_array.append(cell)
	
	return result_array


# Draw the given area, with the give tile
func draw_area(cell_array : Array, tile_id : int) -> void:
	for cell in cell_array:
		set_cellv(cell, tile_id, false, false, false)


# On the draw movement event, find the movement area, and draw it
func _on_draw_movement_area(actor_position, actor_movements):
	find_walkable_cells(actor_position, actor_movements)
	draw_area(walkable_cells, BLUE_CELL)
