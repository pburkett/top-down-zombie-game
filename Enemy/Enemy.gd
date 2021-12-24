extends Node2D
export var view_distance = 400
export var turn_speed = .08
export var hit_points = 100
export var player_spotted = false
func _ready():
	for hitbox_node in 	get_tree().get_nodes_in_group("hitbox"):
		hitbox_node.connect("area_entered", self, "_on_hurtbox_area_entered")

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
		if dot > .4  and distance_to_player < view_distance:	
			turn_towards_player(currently_facing, vector_to_player)

			if dot > .8 :
				if $FireRate.is_stopped():
					$FireRate.start()
	else:
		$FireRate.stop()


func turn_towards_player(currently_facing, vector_to_player)->void:
	rotation = lerp(currently_facing, vector_to_player, turn_speed).angle()

func _on_hurtbox_area_entered(area ):
	for item in $Hurtbox.get_overlapping_areas():
		if item.is_in_group('hitbox'):
			take_damage(item.damage)

func take_damage(damage_amount):
	hit_points -= damage_amount
	if hit_points <= 0:
		die()

func die():
	queue_free()

func _on_FireRate_timeout():
	print('timeout')
	var scene = load("res://Bullet.tscn")
	var new_bullet = scene.instance()
	var currently_facing = Vector2(cos(rotation), sin(rotation))
	new_bullet.add_central_force(currently_facing * 1000)
	new_bullet.position = global_position + currently_facing * 5
	get_node("/root/Level").add_child(new_bullet)
