extends Node2D

onready var enemy = get_node("/root/Main/Level/Path2D/Enemy")
onready var path_2d = get_node("/root/Main/Level/Path2D")
onready var nav_2d = get_node("/root/Main/Level/Navigation")

func _ready():
	pass
	
func _input(ev):
	if Input.is_action_just_pressed('ui_escape'):
		get_tree().quit()
	if Input.is_action_just_pressed('ui_restart'):
		restart_level()
		
func restart_level():
	for node in get_children():
		print(node)
		node.free()
	get_tree().reload_current_scene()


