extends RigidBody2D
var collisions = 0
export var collisions_before_dissapear = 2
var is_dying = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play('traveling')
	pass

func _physics_process(delta):
	rotation = linear_velocity.angle() + .5*PI

func _integrate_forces(state):
	if state.get_contact_count() == 1:
		collisions += 1
	if (collisions >= collisions_before_dissapear) and !is_dying:
		print('die animation start')
		is_dying = true
		set_linear_velocity(Vector2(0,0))
		$PhysicsCollision.set_deferred("disabled", true)
		$AnimatedSprite.play('impact_metal')
		print(connect("animation_finished", $AnimatedSprite, "remove"))
		

func _on_AnimatedSprite_animation_finished():
	if is_dying:
		queue_free()  
