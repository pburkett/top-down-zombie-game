extends RigidBody2D
export var damage = 100




# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _physics_process(delta):
	
	rotation = linear_velocity.angle() + .5*PI


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
