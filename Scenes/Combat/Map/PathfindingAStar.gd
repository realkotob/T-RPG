tool
extends Map
class_name CombatMap

# Create a Astar node and store it in the variable astar_node
onready var astar_node = AStar.new()
onready var _half_cell_size = Vector2(16, 8) 
onready var ground_0_node = $Layer/Ground

onready var grounds_tilemap = ground_0_node
onready var obstacles_tilemap = $Layer/Obstacles

var path_start_position : Vector2 setget set_path_start_position
var path_end_position : Vector2 setget set_path_end_position

var map_size = Vector2(100, 100)
var grounds
var obstacles
var _point_path := PoolVector3Array()

const BASE_LINE_WIDTH = 4.0
const DRAW_COLOR = Color('#fff')


func _ready():
	# Store all the passable cells into the array grounds
	grounds = grounds_tilemap.get_used_cells()
	
	# Store all the unpassable cells into the array obstacles
	obstacles = obstacles_tilemap.get_used_cells()
	
	# Store all the passable cells into the array walkable_cells_list, by checking all the cells in the map to see if they are not an obstacle
	var walkable_cells_list = astar_add_walkable_cells()
	
	# Create the connections between all the walkable cells
	astar_connect_walkable_cells(walkable_cells_list)


# Determine which cells are walkale and which are not
func astar_add_walkable_cells():
	var points_array = []
	
	# Go through all the cells of the map, and check if they are in the obstacles array
	for i in range (len(grounds)):
		
		# Store the coordonates of the current cell, check if it is in the obstacles array, and if it is: skip to the next cell
		var point = grounds[i]
		if point in obstacles:
			continue
		
		# Add the last cell checked in the array of points we will create in the astar_node
		points_array.append(point)
		
		# Caculate an index for our point, and add it to the astar_node
		var point_index = calculate_point_index(point)
		astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	
	return points_array


# Connect walkables cells together
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		# Store the current point's index we are checking in point_index
		var point_index = calculate_point_index(point)
		
		# Store the four surrounding points of the point we are checking in points_relative
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		
		# Loop through the for relative points of the current point
		for current_point_relative in points_relative:
			var current_point_relative_index = calculate_point_index(current_point_relative)
			
			# If the current relative point is outside the map, or if it is not inside the astar_node, skip to the next relative
			if is_outside_map_bounds(current_point_relative):
				continue
			if not astar_node.has_point(current_point_relative_index):
				continue
			
			# If not, add a connection with the origin point
			astar_node.connect_points(point_index, current_point_relative_index, true)


# Return true if the given point is outside the map bounds
func is_outside_map_bounds(point):
	return !(point in grounds)


# Return the point index
func calculate_point_index(point):
	return point.x + map_size.x * point.y


# Retrun the shortest path between two points, or an empty path if there is no path to take to get there
func find_path(world_start, world_end) -> Array:
	# Set the start and end point
	set_path_start_position(ground_0_node.world_to_map(world_start))
	set_path_end_position(ground_0_node.world_to_map(world_end))
	
	# Calculate a path between this two points
	calculate_path()
	
	# Convert the path from a point path, to a path of coordonates in the game world
	var path_world = []
	for point in _point_path:
		var point_world = ground_0_node.map_to_world(Vector2(point.x, point.y))
		point_world.y += _half_cell_size.y
		path_world.append(point_world)
	
	return path_world


# Calculate the path between two positions
func calculate_path():
	# Check if the given start and end points are valid, retrun an empty array if not
	if path_start_position == Vector2() or path_end_position == Vector2():
		_point_path = []
		return
	
	# Calculate the start and the end point index
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	
	# Find a path between this two points, and store it into _point_path
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)


# Set the start path to the given value, unless this point is an obstacle or outside the map
func set_path_start_position(point) -> void:
	if !is_position_valid(point):
		point = Vector2()
	path_start_position = point


# Set the end path to the given value, unless this point is an obstacle or outside the map
func set_path_end_position(point) -> void:
	if !is_position_valid(point):
		point = Vector2()
	path_end_position = point


# Check if a position is valid, return true if it is, false if it is not
func is_position_valid(point: Vector2) -> bool:
	return !(point in obstacles or is_outside_map_bounds(point))
