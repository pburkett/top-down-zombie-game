extends RigidBody2D
var collisions = 0
export var collisions_before_dissapear = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	
	rotation = linear_velocity.angle() + .5*PI

func _integrate_forces(state):
	if state.get_contact_count() == 1:
		collisions += 1
	if collisions >= collisions_before_dissapear:
		queue_free()  

