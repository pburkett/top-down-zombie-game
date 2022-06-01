extends Node2D

export var current_level : int

func _ready():
	set_current_level(0)
	load_gui()

func _process(delta):
	if Input.is_action_just_released('ui_restart'):
		restart_level()
	# TODO remove this when in prod
	if Input.is_action_just_released('ui_quit'):
		get_tree().quit()	
	
	

func restart_level():
	for node in get_tree().get_nodes_in_group("clear_on_level_reload"):
		node.queue_free()
	get_tree().reload_current_scene()


func set_current_level(new_level_number):
	# 	# Remove the current level	
	# var level = root.get_node("Level")
	# root.remove_child(level)
	# level.call_deferred("free")

	# Add the next level
	var path = "res://Levels/level_" + str(new_level_number) +  "/Level"
	var next_level_resource = load(path + ".tscn")
	var next_level = next_level_resource.instance()
	add_child(next_level)
	print(get_children())

func load_gui():
	var gui_resource = load("res://GUI/GUI.tscn")
	var gui = gui_resource.instance()
	add_child(gui)
