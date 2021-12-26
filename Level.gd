extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input(ev):
	if ev is InputEventKey:
		if ev.scancode == KEY_R:
			restart_level()
		elif ev.scancode == KEY_ESCAPE: 
			get_tree().quit()	

func restart_level():
	for node in get_tree().get_nodes_in_group("clear_on_level_reload"):
		node.queue_free()
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
