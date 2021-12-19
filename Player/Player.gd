extends KinematicBody2D

export var max_speed = 300
export var swipe_speed_boost_percentage = 100
export var swipe_cooldown_speed_penalty = -30
export var acceleration_speed = .1
export var deceleration_speed = .10
export var turn_speed = .1
var velocity = Vector2()
var is_attacking = false
var is_in_attack_cooldown = false

func _ready():
	pass

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
	print($AnimatedSprite.get_speed_scale())

	var direction = get_input()	

	if Input.is_action_just_pressed('swipe') and !is_in_attack_cooldown:
		is_attacking = true
	var current_max_speed = get_max_speed()
	print(current_max_speed, is_in_attack_cooldown)
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * current_max_speed, acceleration_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, deceleration_speed)
	move_and_slide(velocity)
	rotate_sprite()
	choose_animation()

func get_max_speed()->float:
	# var current_max_speed = max_speed if !is_attacking else max_speed * (swipe_speed_boost_percentage / 100 + 1)
	var current_max_speed: float = float(max_speed)
	if is_attacking:
		current_max_speed *= (swipe_speed_boost_percentage / 100.0 + 1)
	elif is_in_attack_cooldown:
		current_max_speed *= ( swipe_cooldown_speed_penalty / 100.0 + 1)
	return current_max_speed

func rotate_sprite()->void:
	var new_angle
	if is_attacking:
		new_angle = stepify($AnimatedSprite.rotation, .25*PI) 
	else:
		new_angle = lerp_angle($AnimatedSprite.rotation, velocity.angle() + .5*PI, .1)
	$AnimatedSprite.rotation = new_angle
	$CollisionShape2D.rotation = new_angle

func _on_AnimatedSprite_animation_finished()->void:
	if $AnimatedSprite.animation == 'swipe':
		is_in_attack_cooldown = true
		is_attacking = false		
		$AnimatedSprite.play('stationary')
		$AttackEndLag.start()

	if $AnimatedSprite.animation == 'walk':
		if velocity.length() < .5:
			$AnimatedSprite.play('stationary')

func choose_animation()->void:
	if is_in_attack_cooldown:
		$AnimatedSprite.set_speed_scale(( swipe_cooldown_speed_penalty / 100.0 + 1))
	else:
		$AnimatedSprite.set_speed_scale(1)

	if is_attacking:
		$AnimatedSprite.play('swipe')
	elif velocity.length() > .2:
		$AnimatedSprite.play('walk')

func _on_Timer_timeout()->void:
	is_in_attack_cooldown = false
