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
			get_tree().change_scene("res://Level.tscn")
		elif ev.scancode == KEY_ESCAPE: 
			get_tree().quit()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
