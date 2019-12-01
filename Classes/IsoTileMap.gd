extends TileMap

class_name IsoTileMap

# Define the map size, in cells
export(Vector2) var map_size : Vector2

# Return the point index
func calculate_point_index(point):
	return point.x + map_size.x * point.y