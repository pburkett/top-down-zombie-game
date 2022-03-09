tool
extends TileSet

const WALL = 1
const FLOOR = 0

var binds = {
	WALL: [FLOOR],
	
}

func _is_tile_bound(id, nid):
	if binds.get(id):
		return nid in binds[id]