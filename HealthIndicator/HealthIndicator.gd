extends Node2D

onready var player_node = get_node("/root/Main/Level/Player")

func _ready():
	pass

func _process(delta):
	var health_proportion = (float(player_node.hit_points) / player_node.max_hit_points) * 4
	$Sprite.texture = load("res://HealthIndicator/Assets/" + str(health_proportion) + "_lobes.png")
