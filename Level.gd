extends Node2D

onready var enemy = get_node("/root/Level/Path2D/Enemy")
onready var path_2d = get_node("/root/Level/Path2D")
onready var nav_2d = get_node("/root/Level/Navigation")

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

# func _unhandled_input(event: InputEvent) -> void:
# 	if not event is InputEventMouseButton:
# 		return
# 	if event.button_index != BUTTON_LEFT or not event.pressed:
# 		return

# 	var new_path = nav_2d.get_simple_path(enemy.global_position, event.position.round())
# 	print(enemy.global_position, event.position.round(), new_path)
# 	print(Vector2(200,200), event.position.round(), new_path)
# 	var curve = path_2d.get_curve()
# 	curve.clear_points()
	
# 	for point in new_path:
# 		curve.add_point(to_local(point))
# 	enemy.offset = 0
