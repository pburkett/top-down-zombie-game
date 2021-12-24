extends Node2D
export var view_distance = 400
export var turn_speed = .08
export var hit_points = 100

func _ready():
	get_node("/root/Level/Player/Swipe").connect("area_entered", self, "_on_hurtbox_area_entered")

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

func turn_towards_player(currently_facing, vector_to_player)->void:
	rotation = lerp(currently_facing, vector_to_player, turn_speed).angle()

func shoot()->void:
	pass

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
