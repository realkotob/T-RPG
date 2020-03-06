extends TileMap

class_name IsoTileMap

# Define the map size, in cells
export(Vector2) var map_size : Vector2

# Return the point index
func calculate_point_index(point):
	return point.x + map_size.x * point.y

## World to map in a iso context, with the origin on the center
#func world_to_map_iso(pos : Vector2) -> Vector2:
#	var given_pos = pos
#	given_pos = iso_offset(given_pos)
#	given_pos = world_to_map(given_pos)
#	return given_pos
#
## Map to world in a iso context, with the origin on the center
#func map_to_world_iso(pos : Vector2) -> Vector2:
#	var given_pos = pos
#	given_pos = map_to_world(given_pos)
#	given_pos = iso_offset(given_pos)
#	return given_pos
#
#func iso_offset(pos : Vector2) -> Vector2:
#	var given_pos = pos
#	given_pos.x += cell_size.x/2
#	given_pos.y -= cell_size.y/2
#	return given_pos
