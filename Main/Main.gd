extends Node2D

var level_number = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(ev):
	var input = Vector2()
	if Input.is_action_just_released('ui_restart'):
		restart_level()
	# TODO remove this when in prod
	elif ev.scancode == KEY_ESCAPE: 
		get_tree().quit()	

func restart_level():
	for node in get_tree().get_nodes_in_group("clear_on_level_reload"):
		node.queue_free()
	get_tree().reload_current_scene()
