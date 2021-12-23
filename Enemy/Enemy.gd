extends Node2D
export var view_distance = 400
func _ready():
	pass 

func _process(delta):
	pass

func _physics_process(delta):
	handle_rotation()



func handle_rotation()->void:
	var player_node = get_node("/root/Level/Player")
	var currently_facing = Vector2(cos(rotation), sin(rotation))
	var vector_to_player = position.direction_to(player_node.get_position())
	var dot = vector_to_player.dot(currently_facing)

	if $CastToPlayer.get_collider() == player_node:
		var distance_to_player = $CastToPlayer.get_collision_point().distance_to(global_position)
		if dot > .5 and distance_to_player < view_distance:	
			if dot > .9:
				shoot()
			turn_towards_player(currently_facing, vector_to_player)
	else: 
		print('mustve been the wind')

func turn_towards_player(currently_facing, vector_to_player)->void:
	rotation = lerp(currently_facing, vector_to_player, .15).angle()
	print('turn')

func shoot()->void:
	print('pew pew')
