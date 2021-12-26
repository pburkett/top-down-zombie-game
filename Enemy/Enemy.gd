extends Node2D
export var view_distance = 400
export var turn_speed = .08
export var hit_points = 100
export var  bullets_per_second = 1.0
export var bullet_speed = 1000
export var possible_statuses = {"idle": "idle", "alerted": "idle", "player_spotted": "turn_towards_player", "firing": "shoot"}
var status = "idle"
var bullet = preload("res://Bullet/Bullet.tscn")
var currently_facing 
var vector_to_player
onready  var player_node = get_node("/root/Level/Player")

func _ready():
	connect("area_entered", self, "_on_hurtbox_area_entered")
	$FireRate.wait_time = 1 / bullets_per_second

func _process(delta):
	pass

func _physics_process(delta):
	set_status()
	call(possible_statuses[status])

func idle():
	#play idle animation
	pass

func shoot():
	turn_towards_player()
	if $FireRate.is_stopped():
		$FireRate.start()

func set_status()->void:
	currently_facing = Vector2(cos(rotation), sin(rotation))
	vector_to_player = position.direction_to(player_node.get_position())			
	if $CastToPlayer.get_collider() == player_node:
		var dot = vector_to_player.dot(currently_facing)
		var distance_to_player = $CastToPlayer.get_collision_point().distance_to(global_position)
		if dot > .4  and distance_to_player < view_distance:
			if dot > .8 :
				status = "firing"
			else: 
				status = "player_spotted"
		else:
			status = "idle"
	else:
		status = "alerted"

func turn_towards_player()->void:
	rotation = lerp(currently_facing, vector_to_player, turn_speed).angle()

func _on_Hurtbox_area_entered(area ):
	if area.is_in_group('hitbox'):
		take_damage(area.damage)

func take_damage(damage_amount):
	hit_points -= damage_amount
	if hit_points <= 0:
		die()

func die():
	queue_free()

func _on_FireRate_timeout():
	var new_bullet = bullet.instance()
	var currently_facing = Vector2(cos(rotation), sin(rotation))
	new_bullet.apply_impulse(Vector2.ZERO, currently_facing * bullet_speed)
	new_bullet.position = global_position + currently_facing * 30
	new_bullet.rotation = currently_facing.angle()
	print(new_bullet.rotation)
	get_tree().get_root().call_deferred("add_child",new_bullet)
