extends TileSet

func ready():
	var tiles = get_tiles_ids()
	var tiles_nb = len(tiles) - 1
	
	for i in range(tiles_nb):
		var tile_tex_offset = tile_get_texture_offset(tiles[i])
		tile_set_occluder_offset(tiles[i], tile_tex_offset)
