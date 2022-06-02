extends TileMap

onready var door_scene = preload("./Door.tscn")
onready var main = get_node("/root/Main")

func _ready():
	var door_tiles = get_used_cells_by_id(19)	
	load_doors(door_tiles)


func load_doors(door_tiles):
	for door_tile in door_tiles:
		var door_node = door_scene.instance()
		set_position_tile_node(door_tile, door_node)
		set_rotation_tile_node(door_tile, door_node)
		add_child(door_node)

func set_position_tile_node(tile, node):
	var pos = map_to_world(tile)
	pos[0] += 16
	pos[1] += 16
	node.set_position(pos)

func set_rotation_tile_node(tile,node):
	node.rotation = get_tile_rotation(tile)


func get_tile_rotation(door_tile):
	var xflip = is_cell_x_flipped(door_tile[0], door_tile[1])
	# var yflip = is_cell_y_flipped(door_tile[0], door_tile[1])
	var transpose = is_cell_transposed(door_tile[0], door_tile[1])

	if (!xflip and !transpose):
		return 0.0
	elif(xflip  and !transpose ):
		return PI 
	elif(!xflip and transpose):
		return -PI/2
	elif(xflip and transpose):
		return PI/2 
	return []


