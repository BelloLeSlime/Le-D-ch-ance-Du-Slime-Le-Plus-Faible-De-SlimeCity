extends TileMap

func _ready():
	var filled_tiles := get_used_cells(0)
	for filled_tile: Vector2i in filled_tiles:
		var neighboring_tiles := get_surrounding_cells(filled_tile)
		for neighbor: Vector2i in neighboring_tiles:
			if get_cell_source_id(0, neighbor) == -1:
				set_cell(0,neighbor,0,Vector2i(1,0))
