tool
extends Map
class_name CombatMap

onready var astar_node = AStar.new()

onready var ground_0_node = $Layer/Ground
onready var obstacles_tilemap = $Interactives/Obstacles
onready var area_node = $Interactives/Areas

var layer_ground_array : Array

var path_start_position : Vector3 setget set_path_start_position
var path_end_position : Vector3 setget set_path_end_position

var grounds : PoolVector3Array = []
var obstacles : PoolVector3Array = []
var cell_path : PoolVector3Array = []

#### ACCESSORS ####

# Set the start path to the given value, unless this cell is an obstacle or outside the map
func set_path_start_position(cell: Vector3) -> void:
	if !is_position_valid(cell):
		cell = Vector3()
	path_start_position = cell


# Set the end path to the given value, unless this cell is an obstacle or outside the map
func set_path_end_position(cell: Vector3) -> void:
	if !is_position_valid(cell):
		cell = Vector3()
	path_end_position = cell


func _ready():
	if Engine.editor_hint:
		return
	
	# Store every layers in the layer_ground_array
	for child in get_children():
		if child.name != "Layer":
			child.set_visible(false)
		
		if child is MapLayer:
			layer_ground_array.append(child.get_node("Ground"))
	
	# Store all the passable cells into the array grounds
	grounds = generate_walakable_grounds()
	
	# Store all the unpassable cells into the array obstacles
	obstacles = obstacles_tilemap.get_used_cells()
	
	# Store all the passable cells into the array walkable_cells_list, by checking all the cells in the map to see if they are not an obstacle
	var walkable_cells_list = astar_add_walkable_cells(grounds)
	
	# Create the connections between all the walkable cells
	astar_connect_walkable_cells(walkable_cells_list)
	
	# Give every actor, his default grid pos
	init_actors_grid_pos()


# Get the highest cell of every cells in the 2D plan,
# Returns a 3 dimentional coordinates array of cells
func generate_walakable_grounds() -> PoolVector3Array:
	var walkable_grounds : PoolVector3Array = []
	for i in range(layer_ground_array.size() - 1, -1, -1):
		for cell in layer_ground_array[i].get_used_cells():
			if find_2D_cell(Vector2(cell.x, cell.y), walkable_grounds) == Vector3.INF:
				walkable_grounds.append(Vector3(cell.x, cell.y, i))
	
	return walkable_grounds


# Find if a cell x and y is already in the Vector3 grid, and returns it
# Return Vector3.INF if nothing was found
func find_2D_cell(cell : Vector2, grid: PoolVector3Array = grounds) -> Vector3:
	for grid_cell in grid:
		if (cell.x == grid_cell.x) && (cell.y == grid_cell.y):
			return grid_cell
	return Vector3.INF


# Return the layer at the given height
func get_layer(height: int) -> MapLayer:
	return layer_ground_array[height].get_parent()


# Return the id of the layer at the given height
func get_layer_id(height: int) -> int:
	return get_layer(height).get_index()


# Return the highest layer where the given cell is used
# If the given cell is nowhere: return -1
func get_cell_highest_layer(cell : Vector2) -> int:
	for i in range(layer_ground_array.size() - 1, -1, -1):
		if cell in layer_ground_array[i].get_used_cells():
			return i
	return -1


# Return the highest cell in the grid at the given world position
func get_pos_highest_cell(pos: Vector2) -> Vector3:
	var ground_0_cell_2D = ground_0_node.world_to_map(pos)
	for i in range(layer_ground_array.size() - 1, -1, -1):
		var current_cell_2D = ground_0_cell_2D + Vector2(i, i)
		var current_cell_3D = Vector3(current_cell_2D.x, current_cell_2D.y, i)
		if current_cell_3D in grounds:
			return current_cell_3D
	return Vector3.INF


# Give every actor, his default grid pos
func init_actors_grid_pos():
	for actor in get_tree().get_nodes_in_group("Actors"):
		actor.map_node = self
		actor.set_grid_position(get_pos_highest_cell(actor.position))


# Determine which cells are walkale and which are not
func astar_add_walkable_cells(cell_array : PoolVector3Array):
	var passable_cell_array : PoolVector3Array = []
	
	# Go through all the cells of the map, and check if they are in the obstacles array
	for cell in cell_array:
		# Add the last cell checked in the array of points we will create in the astar_node
		passable_cell_array.append(cell)
		
		# Caculate an index for our cell, and add it to the astar_node
		var cell_index = compute_cell_index(cell)
		astar_node.add_point(cell_index, cell)
	
	return passable_cell_array


# Connect walkables cells together
func astar_connect_walkable_cells(cells_array: PoolVector3Array):
	for cell in cells_array:
		# Store the current cell's index we are checking in cell_index
		var cell_index = compute_cell_index(cell)
		
		# Store the four surrounding points of the cell we are checking in cell_relative
		var cell_relative_array = PoolVector2Array([
			Vector2(cell.x + 1, cell.y),
			Vector2(cell.x - 1, cell.y),
			Vector2(cell.x, cell.y + 1),
			Vector2(cell.x, cell.y - 1)])
		
		# Loop through the for relative points of the current cell
		for cell_relative in cell_relative_array:
			var cell3D_relative = Vector3(cell_relative.x, cell_relative.y, 0)
			var cell_relative_index = compute_cell_index(cell3D_relative)
			
			# If the current relative cell is outside the map, or if it is not inside the astar_node, skip to the next relative
			if find_2D_cell(cell_relative, cells_array) == Vector3.INF:
				continue
			if not astar_node.has_point(cell_relative_index):
				continue
			
			# If not, add a connection with the origin cell
			astar_node.connect_points(cell_index, cell_relative_index, true)


# Return true if the given cell is outside the map bounds
func is_outside_map_bounds(cell: Vector3):
	return !(cell in grounds)


# Return the cell index
func compute_cell_index(cell: Vector3):
	return abs(cell.x + grounds.size() * cell.y)


# Retrun the shortest path between two points, or an empty path if there is no path to take to get there
func find_path(start_cell: Vector3, end_cell: Vector3) -> PoolVector3Array:
	# Set the start and end cell
	set_path_start_position(start_cell)
	set_path_end_position(end_cell)
	
	# Calculate a path between this two points
	calculate_path()
	
	return cell_path


# Calculate the path between two positions
func calculate_path():
	# Check if the given start and end points are valid, retrun an empty array if not
	if path_start_position == Vector3() or path_end_position == Vector3():
		cell_path = []
		return
	
	# Calculate the start and the end cell index
	var start_point_index = compute_cell_index(path_start_position)
	var end_point_index = compute_cell_index(path_end_position)
	
	# Find a path between this two points, and store it into cell_path
	cell_path = astar_node.get_point_path(start_point_index, end_point_index)


# Draw the movement of the given character
func draw_movement_area(active_actor : Actor):
	var mov = active_actor.get_current_movements()
	var map_pos = active_actor.get_grid_position()
	var walkable_cells := find_reachable_cells(map_pos, mov)
	area_node.draw_area(walkable_cells)


# Take a cell and return its world position
func cell_to_world(cell: Vector3) -> Vector2:
	var pos = ground_0_node.map_to_world(Vector2(cell.x, cell.y))
	pos.y -= cell.z * 16
	return pos


# Take an array of cells, and return an array of corresponding world positions
func cell_array_to_world(cell_array: PoolVector3Array) -> PoolVector2Array:
	var pos_array : PoolVector2Array = []
	for cell in cell_array:
		var new_pos = cell_to_world(cell)
		if !new_pos in pos_array:
			pos_array.append(new_pos)
	
	return pos_array


# Find all the walkable cells and retrun their position
func find_reachable_cells(actor_map_pos : Vector3, actor_movements : int) -> PoolVector3Array:
	
	var reachable_cells : PoolVector3Array = []
	var relatives : PoolVector3Array
	
	for i in range(1, actor_movements + 1):
		# Find the adjacents cells of the current cell
		if i == 1:
			relatives = find_relatives([actor_map_pos], reachable_cells)
		else:
			relatives = find_relatives(relatives, reachable_cells)
		
		# Check for every points if it is valid, not already treated 
		# and if a path exist between the actor's position and it
		for cell in relatives:
			if is_position_valid(cell) && !cell in reachable_cells:
				
				# Get the lenght of the path between the actor
				var path_len = len(find_path(actor_map_pos, cell))
				if path_len > 0 && path_len - 1 <= actor_movements:
					reachable_cells.append(cell)
	
	return reachable_cells


# Find all the relatives to an array of points, checking if they haven't been treated before, 
# and return it in an array
func find_relatives(point_array : PoolVector3Array, reachable_cells: PoolVector3Array) -> PoolVector3Array:
	var result_array : PoolVector3Array = []
	
	for cell in point_array:
		var point_relative = PoolVector2Array([
		Vector2(cell.x + 1, cell.y),
		Vector2(cell.x - 1, cell.y),
		Vector2(cell.x, cell.y + 1),
		Vector2(cell.x, cell.y - 1)])
		
		for relative in point_relative:
			# If the current cell asn't been treated yet
			var cell3D = find_2D_cell(relative, grounds)
			if not cell3D in reachable_cells:
				result_array.append(cell3D)
	
	return result_array


# Check if a position is valid, return true if it is, false if it is not
func is_position_valid(cell: Vector3) -> bool:
	return !(cell in obstacles or is_outside_map_bounds(cell))
