extends Object
class_name IsoLib


#### LOGIC ####

# Return every cells at the given dist or more from the origin in the given array
static func get_cells_at_xy_dist(origin: Vector3, dist: int, cells_array: PoolVector3Array) -> PoolVector3Array:
	var cells_at_dist = PoolVector3Array()
	for cell in cells_array:
		if cell == origin: continue
		var x_sum_diff = abs(cell.x - origin.x)
		var y_sum_diff = abs(cell.y - origin.y)
		var dif = x_sum_diff + y_sum_diff
		if dif >= dist:
			cells_at_dist.append(cell)
	return cells_at_dist

