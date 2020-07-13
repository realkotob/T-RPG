tool
extends Map
class_name CombatMap

onready var layer_0_node = $Layer
onready var area_node = $Interactives/Areas
onready var pathfinding = $Pathfinding

var layer_array : Array

var grounds : PoolVector3Array = []
var cell_path : PoolVector3Array = []

var walkable_cells : PoolVector3Array = []
var obstacles : Array = [] setget set_obstacles, get_obstacles

var active_actor: Actor = null setget set_active_actor

var is_ready : bool = false


#### ACCESSORS ####

func set_obstacles(array: Array):
	if array != obstacles:
		obstacles = array
		walkable_cells = pathfinding.set_walkable_cells(grounds)
		pathfinding.connect_walkable_cells(walkable_cells, active_actor)


func get_obstacles() -> Array:
	return obstacles

func set_active_actor(value : Actor):
	active_actor = value


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
	
	yield(owner, "ready")
	
	# Store all the passable cells into the array walkable_cells_list, 
	# by checking all the cells in the map to see if they are not an obstacle
	walkable_cells = pathfinding.set_walkable_cells(grounds)
	
	# Create the connections between all the walkable cells
	pathfinding.connect_walkable_cells(walkable_cells, active_actor)
	
	is_ready = true


#### LOGIC ####

# Return an array of cells at the given world position
func get_cell_stack_at_pos(world_pos: Vector2) -> PoolVector3Array:
	var cell_stack : PoolVector3Array = [] 
	var highest_cell = get_pos_highest_cell(world_pos)
	cell_stack.append(highest_cell)
	
	for z in range(highest_cell.z - 1, -1, -1):
		var world_pos_adapted = Vector2(world_pos.x, world_pos.y + 16 * z)
		var cell_2D = layer_array[z].world_to_map(world_pos_adapted)
		var cell_3D = Vector3(cell_2D.x, cell_2D.y, z)
		if is_position_valid(cell_3D):
			cell_stack.append(cell_3D)
	
	return cell_stack


# Recursivly search for the deepest node of every branch
# If the deepest node is a Sprite, an AnimatedSprite or a TileMap: hide it
# Exeception with the ground0 (Bescause its rendered by the engine) 
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


# Find if a cell x and y is in the heightmap grid, and returns it
# Return Vector3.INF if nothing was found
func find_2D_cell(cell : Vector2, grid: PoolVector3Array = grounds) -> Vector3:
	for grid_cell in grid:
		if (cell.x == grid_cell.x) && (cell.y == grid_cell.y):
			return grid_cell
	return Vector3.INF


# Return the cell in the ground 0 grid pointed by the given position
func world_to_ground_z(pos : Vector2, z : int = 0):
	pos.y -= z * 16
	return layer_array[z].world_to_map(pos)

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
# Can optionaly find it, starting from a given layer (To ignore higher layers)
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
		actor.set_current_cell(get_pos_highest_cell(actor.position))


# Return true if the given cell is outside the map bounds
func is_outside_map_bounds(cell: Vector3):
	return !(cell in grounds)



# Draw the movement of the given character
func draw_movement_area():
	var mov = active_actor.get_current_movements()
	var map_pos = active_actor.get_current_cell()
	var reachable_cells = pathfinding.find_reachable_cells(map_pos, mov)
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


# Return true if the given cell is occupied by an obstacle
func is_cell_in_obstacle(cell: Vector3) -> bool:
	for obst in obstacles:
		if cell == obst.get_current_cell():
			return true
	return false


# Check if a position is valid, return true if it is, false if it is not
func is_position_valid(cell: Vector3) -> bool:
	var no_obstacle : bool = !is_cell_in_obstacle(cell)
	var inside_boundes : bool = !is_outside_map_bounds(cell)
	var is_walkable : bool = cell in walkable_cells
	
	return no_obstacle && inside_boundes && is_walkable 


# Get the adjacent cells of the given one
func get_adjacent_cells(cell: Vector3):
	var adjacents : PoolVector3Array = []
	var relatives : Array = [
		Vector2(cell.x + 1, cell.y),
		Vector2(cell.x, cell.y + 1),
		Vector2(cell.x - 1, cell.y),
		Vector2(cell.x, cell.y - 1)
	]
	
	for relative in relatives:
		var adj = find_2D_cell(relative)
		if adj != Vector3.INF:
			adjacents.append(adj)
	
	return adjacents
