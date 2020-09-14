extends Node

onready var map_node = get_parent()

# Return the line between two given points 
func get_line(origin: Vector3, dest: Vector3) -> PoolVector3Array:
	var line2D = get_line_2D(Vector2(origin.x, origin.y), Vector2(dest.x, dest.y))
	return map_node.array2D_to_grid_cells(line2D)


# Get every cells visible between the origin and the dest
func get_line_of_sight(origin: Vector3, dest: Vector3) -> PoolVector3Array:
	var line = get_line(origin, dest)
	var line_of_sight : PoolVector3Array = []
	var to_dest_slope = get_slope(origin, dest)
	for cell in line:
		if cell == origin:
			continue
		
		var obj : IsoObject = map_node.get_object_on_cell(cell)
		var obj_visible_point = cell
		var current_slope : int = 0
		
		if obj == null: # Empty cell
			current_slope = get_slope(origin, cell)
		else: # Cell with an object
			var obj_cell = obj.get_current_cell()
			var obj_height = obj.get_grid_height()
			obj_visible_point = obj_cell
			obj_visible_point.z += obj_height
			current_slope = get_slope(origin, obj_visible_point)
		
		line_of_sight.append(cell)
		
		if current_slope > to_dest_slope:
			if obj:
				if obj_visible_point.z > origin.z:
					break
			elif cell.z > origin.z:
				 break
	
	return line_of_sight


# Get the height dif between the two given cells
func get_slope(cell1: Vector3, cell2 : Vector3) -> int:
	if cell1.z > cell2.z:
		return int(cell1.z - cell2.z) * -1
	else:
		return int(cell2.z - cell1.z)


# Print the grid of the given size, with x for touched cells, and O for untoched ones
func print_grid(grid_size: int, line: Array):
	for i in range(grid_size):
		var char_line : String = ""
		for j in range(grid_size):
			if Vector2(i, j) in line:
				char_line += "X"
			else:
				char_line += "O"
		print(char_line)


func get_line_2D(p0: Vector2, p1: Vector2) -> Array:
	var dx = p1.x - p0.x
	var nx = abs(dx)
	
	if nx == 0:
		return get_vertical_line(p0, p1)
	
	var dy = p1.y - p0.y
	var ny = abs(dy)
	
	if ny == 0:
		return get_horizontal_line(p0, p1)
	
	var sign_x : int
	var sign_y : int
	
	if dx > 0:
		sign_x = 1
	else:
		sign_x = -1
	
	if dy > 0:
		sign_y = 1
	else:
		sign_y = -1
	
	var p = p0 
	var points : Array = [p]
	
	var ix = 0
	var iy = 0
	
	while(ix < nx || iy < ny):
		if (0.5 + ix) / nx == (0.5 + iy) / ny:
			# Next step is diagonal
			p.x += sign_x
			p.y += sign_y
			ix += 1
			iy += 1
		elif (0.5 + ix) / nx < (0.5 + iy) / ny:
			p.x += sign_x
			ix += 1
		else:
			p.y += sign_y
			iy += 1
		
		points.append(Vector2(p.x, p.y))
	
	return points


func get_horizontal_line(p0: Vector2, p1: Vector2) -> Array:
	var points : Array = []
	for i in range(p0.x, p1.x, sign(p1.x - p0.x)):
		points.append(Vector2(i, p0.y))
	points.append(p1)
	return points


func get_vertical_line(p0: Vector2, p1: Vector2) -> Array:
	var points : Array = []
	for i in range(p0.y, p1.y, sign(p1.y - p0.y)):
		points.append(Vector2(p0.x, i))
	points.append(p1)
	return points


## Amit Patel’s algorithm (https://www.redblobgames.com)
#func get_cells_on_line2D(p0: Vector2, p1: Vector2) -> Array:
#	var dx = p1.x - p0.x
#	var dy = p1.y - p0.y
#	var nx = abs(dx)
#	var ny = abs(dy)
#	var signX = sign(dx)
#	var signY = sign(dy)
#	var p = p0
#	var points : Array = [p]
#
#	var ix = 0
#	var iy = 0
#
#	while ix < nx || iy < ny:
#		if((1 + (ix << 1)) * ny < (1 + (iy << 1)) * nx):
#			p[0] += signX
#			ix +=1
#		else:
#			p[1] += signY
#			iy += 1
#		points.append(p)
#	return points
