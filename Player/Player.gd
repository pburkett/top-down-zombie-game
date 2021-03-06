extends KinematicBody2D

export var max_speed = 300
export var acceleration_speed = .1
export var deceleration_speed = .10
export var swipe_speed_boost_percentage = 100
export var swipe_cooldown_speed_penalty = -40
export var turn_speed = .1
export var hit_points = 80
export(int) var max_hit_points = hit_points
var velocity = Vector2()
var is_attacking = false
var is_in_attack_cooldown = false
onready var animator = $AnimationPlayer
onready var sprite = $Sprite
onready var swipe_end_lag_timer = get_node('Swipe/SwipeEndLag')

signal restart_level

func _ready():
	animator.connect("animation_finished", self, "_on_animation_finished")
	var level_node = get_node('/root/Main/Level')
	connect("restart_level", level_node , "restart_level")
	animator.play('idle')
	
func get_input()->Vector2:
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
			input.x += 1
	if Input.is_action_pressed('ui_left'):
			input.x -= 1
	if Input.is_action_pressed('ui_down'):
			input.y += 1
	if Input.is_action_pressed('ui_up'):
			input.y -= 1
	return input

func _physics_process(delta):
	var direction = get_input()	
	if Input.is_action_just_pressed('swipe') and !is_in_attack_cooldown:
		is_attacking = true
	var current_max_speed = get_max_speed()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * current_max_speed, acceleration_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, deceleration_speed)
	move_and_slide(velocity)
	rotate_sprite()

func get_max_speed()->float:
	var current_max_speed = float(max_speed)
	if is_attacking:
		current_max_speed *= (swipe_speed_boost_percentage / 100.0 + 1)
	elif is_in_attack_cooldown:
		current_max_speed *= ( swipe_cooldown_speed_penalty / 100.0 + 1)
	return current_max_speed

func rotate_sprite()->void:
	var new_angle
	if is_attacking:
		new_angle = stepify(rotation, .25*PI) 
	else:
		new_angle = lerp_angle(rotation, velocity.angle() + .5*PI, .1)
	rotation = new_angle
		
func choose_animation(current_animation)->void:
	if is_in_attack_cooldown:
		animator.set_speed_scale(( swipe_cooldown_speed_penalty / 100.0 + 1))
	else:
		animator.set_speed_scale(1)
	if current_animation == 'swipe':
		is_in_attack_cooldown = true
		is_attacking = false		
		animator.play('idle')
		swipe_end_lag_timer.start()

	if is_attacking:
		animator.play('swipe')
	elif velocity.length() > 50:
		animator.play('walk')
	else:
		animator.play('idle')

func _on_Timer_timeout()->void:
	is_in_attack_cooldown = false

func _on_Hurtbox_area_entered(area)->void:
	if area.is_in_group('hitbox'):
		if area.get_parent() != self:
			take_damage(area.damage)
	
func take_damage(damage_amount):
	print('player hit for ', damage_amount, ' points')
	hit_points -= damage_amount
	if hit_points <= 0:
		die()

func die():
	emit_signal("restart_level")		
