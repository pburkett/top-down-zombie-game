extends Camera2D

onready var player_node = get_node("/root/Main/Level/Player")
onready var constraints_node = get_parent()
onready var tilemap_node = get_node("/root/Main/Level/Navigation/Walls")

func _ready():
	var map_limits = tilemap_node.get_used_rect()
	var map_cellsize = tilemap_node.cell_size
	limit_left = map_limits.position.x * map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y
	limit_bottom = map_limits.end.y * map_cellsize.y

func _process(delta):
	position = lerp(position, player_node.global_position, .05)
	

