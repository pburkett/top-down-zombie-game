extends KinematicBody2D

export var max_speed = 300
export var swipe_speed_boost_percentage = 100
export var swipe_cooldown_speed_penalty = -40
export var acceleration_speed = .1
export var deceleration_speed = .10
export var turn_speed = .1
var velocity = Vector2()
var is_attacking = false
var is_in_attack_cooldown = false
onready var animator = $AnimationPlayer
onready var sprite = $Sprite
onready var swipe_end_lag_timer = get_node('Swipe/SwipeEndLag')

func _ready():
	animator.connect("animation_finished", self, "_on_animation_finished")
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
	var current_max_speed: float = float(max_speed)
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
