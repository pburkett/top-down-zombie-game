extends KinematicBody2D

export var max_speed = 300
export var swipe_speed_boost_percentage = 100
export var acceleration_speed = .1
export var deceleration_speed = .10
export var turn_speed = .1
var velocity = Vector2()
var isAttacking = false

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
	var direction = get_input()	

	if Input.is_action_just_pressed('swipe'):
		isAttacking = true
	if direction.length() > 0:
		var current_max_speed = max_speed if !isAttacking else max_speed * (swipe_speed_boost_percentage / 100 + 1)
		velocity = lerp(velocity, direction.normalized() * current_max_speed, acceleration_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, deceleration_speed)
	move_and_slide(velocity)
	rotate_sprite()
	choose_animation()

func rotate_sprite()->void:
	var new_angle
	if isAttacking:
		new_angle = stepify($AnimatedSprite.rotation, .25*PI) 
	else:
		new_angle = lerp_angle($AnimatedSprite.rotation, velocity.angle() + .5*PI, .1)
	$AnimatedSprite.rotation = new_angle
	$CollisionShape2D.rotation = new_angle

func _on_AnimatedSprite_animation_finished()->void:
	if $AnimatedSprite.animation == 'swipe':
		isAttacking = Input.is_action_pressed('swipe')
		if !isAttacking:
			$AnimatedSprite.play('stationary')

	if $AnimatedSprite.animation == 'walk':
		if velocity.length() < .5:
			$AnimatedSprite.play('stationary')

func choose_animation()->void:
	if isAttacking:
		$AnimatedSprite.play('swipe')
	elif velocity.length() > .2:
		$AnimatedSprite.play('walk')
