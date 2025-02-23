extends RigidBody2D

var gravityMultiplier = 10000

func _ready():
	# TODO
	pass

func _process(_delta):
	var force = calcForce() * gravityMultiplier
	print(force)
	constant_force = force
	pass

func calcForce():
	var sum = Vector2(0, 0)
	for planet in PlanetTracker.planets:
		var offset = planet.global_position - self.global_position
		var dist_sqr = offset.length_squared()
		var direction = offset.normalized()
		var force = direction * planet.mass / dist_sqr
		sum += force
	return sum

func _input(event):
	if event is InputEventMouseButton:
		var offset = event.global_position - self.global_position
		var impulse = pow(offset.length(), 0.5) * 25
		apply_impulse(offset.normalized() * impulse)
