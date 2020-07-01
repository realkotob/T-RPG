tool
extends Map
class_name CombatMap

onready var astar_node = AStar.new()

onready var layer_0_node = $Layer
onready var area_node = $Interactives/Areas

var layer_array : Array

var grounds : PoolVector3Array = []
var cell_path : PoolVector3Array = []

var obstacles : Array = [] setget set_obstacles, get_obstacles

var is_ready : bool = false

#### ACCESSORS ####

func set_obstacles(array: Array):
	if array != obstacles:
		obstacles = array
		var walkable_cells = astar_set_walkable_cells(grounds)
		astar_connect_walkable_cells(walkable_cells)

func get_obstacles() -> Array:
	return obstacles

#### BUILT-IN FUNCTIONS ####

func _ready():
	if Engine.editor_hint:
		return
	
	# Store every layers in the layer_ground_array
	for child in get_children():
		if child is MapLayer:
			layer_array.append(child)
	
	# Hide every nodes that the engine should be rendering (except ground0)
	hide_all_rendered_nodes(self)
	
	# Store all the passable cells into the array grounds
	grounds = fetch_ground()
	
	# Store all the passable cells into the array walkable_cells_list, 
	# by checking all the cells in the map to see if they are not an obstacle
	var walkable_cells = astar_set_walkable_cells(grounds)
	
	# Create the connections between all the walkable cells
	astar_connect_walkable_cells(walkable_cells)
	
	is_ready = true


# Recursivly search for the deepest node of every branch
# If the deepest node is a Sprite, an AnimatedSprite or a TileMap: hide it
# Exeception withe the ground0 (Bescause its rendered by the engine) 
func hide_all_rendered_nodes(node: Node):
	if node.get_child_count() == 0:
		if node is Sprite or node is TileMap or node is AnimatedSprite:
			if node != layer_0_node:
				node.set_visible(false)
	else:
		for child in node.get_children():
			hide_all_rendered_nodes(child)


# Get the highest cell of every cells in the 2D plan,
# Returns a 3 dimentional coordinates array of cells
func fetch_ground() -> PoolVector3Array:
	var feed_array : PoolVector3Array = []
	for i in range(layer_array.size() - 1, -1, -1):
		for cell in layer_array[i].get_used_cells():
			if find_2D_cell(Vector2(cell.x, cell.y), feed_array) == Vector3.INF:
				feed_array.append(Vector3(cell.x, cell.y, i))
	
	return feed_array


# Find if a cell x and y is in the Vector3 grid, and returns it
# Return Vector3.INF if nothing was found
func find_2D_cell(cell : Vector2, grid: PoolVector3Array = grounds) -> Vector3:
	for grid_cell in grid:
		if (cell.x == grid_cell.x) && (cell.y == grid_cell.y):
			return grid_cell
	return Vector3.INF


# Return the cell in the ground 0 grid pointed by the given position
func world_to_ground0(pos : Vector2):
	return layer_0_node.world_to_map(pos)

# Return the layer at the given height
func get_layer(height: int) -> MapLayer:
	return layer_array[height].get_parent()


# Return the id of the layer at the given height
func get_layer_id(height: int) -> int:
	return get_layer(height).get_index()


# Return the highest layer where the given cell is used
# If the given cell is nowhere: return -1
func get_cell_highest_layer(cell : Vector2) -> int:
	for i in range(layer_array.size() - 1, -1, -1):
		if cell in layer_array[i].get_used_cells():
			return i
	return -1


# Return the highest cell in the grid at the given world position
# Can optionaly find it starting from a given layer (To ignore higher layers)
func get_pos_highest_cell(pos: Vector2, max_layer: int = 0) -> Vector3:
	var ground_0_cell_2D = layer_0_node.world_to_map(pos)
	
	var nb_grounds = layer_array.size()
	if max_layer == 0 or max_layer > nb_grounds:
		max_layer = nb_grounds
		
	for i in range(max_layer - 1, -1, -1):
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
func astar_set_walkable_cells(cell_array : PoolVector3Array):
	var passable_cell_array : PoolVector3Array = []
	astar_node.clear()
	
	# Go through all the cells of the map, and check if they are in the obstacles array
	for cell in cell_array:
		if is_cell_in_obstacle(cell):
			continue
		
		# Add the last cell checked in the array of points we will create in the astar_node
		passable_cell_array.append(cell)
		
		# Caculate an index for our cell, and add it to the astar_node
		var cell_index = compute_cell_index(cell)
		astar_node.add_point(cell_index, cell)
	
	return passable_cell_array


# Return true if the given cell is occupied by an obstacle
func is_cell_in_obstacle(cell: Vector3) -> bool:
	for obst in obstacles:
		if cell == obst.get_grid_position():
			return true
	return false


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
			var cell3D_relative = Vector3(cell_relative.x, 
								cell_relative.y, 
								get_cell_highest_layer(cell_relative))
			
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
	# Check if the given start and end points are valid, retrun an empty array if not
	if start_cell == Vector3.INF or end_cell == Vector3.INF:
		cell_path = []
		return PoolVector3Array()
	
	# Calculate the start and the end cell index
	var start_cell_index = compute_cell_index(start_cell)
	var end_cell_index = compute_cell_index(end_cell)
	
	# Find a path between this two points, and store it into cell_path
	cell_path = astar_node.get_point_path(start_cell_index, end_cell_index)
	
	return cell_path


# Draw the movement of the given character
func draw_movement_area(active_actor : Actor):
	var mov = active_actor.get_current_movements()
	var map_pos = active_actor.get_grid_position()
	var reachable_cells := find_reachable_cells(map_pos, mov)
	area_node.draw_area(reachable_cells)


# Take a cell and return its world position
func cell_to_world(cell: Vector3) -> Vector2:
	var pos = layer_0_node.map_to_world(Vector2(cell.x, cell.y))
	pos.y -= cell.z * 16 - 8
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
func find_reachable_cells(actor_cell : Vector3, actor_movements : int) -> PoolVector3Array:
	
	var reachable_cells : PoolVector3Array = []
	var relatives : PoolVector3Array
	
	for i in range(1, actor_movements + 1):
		# Find the adjacents cells of the current cell
		if i == 1:
			relatives = find_relatives([actor_cell], reachable_cells)
		else:
			relatives = find_relatives(relatives, reachable_cells)
		
		# Check for every points if it is valid, not already treated 
		# and if a path exist between the actor's position and it
		for cell in relatives:
			if is_position_valid(cell) && !(cell in reachable_cells):
				
				# Get the lenght of the path between the actor and the cursor
				var path_len = len(find_path(actor_cell, cell))
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
	return !is_cell_in_obstacle(cell) && !is_outside_map_bounds(cell)
