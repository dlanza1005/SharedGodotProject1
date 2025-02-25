extends RigidBody2D

var gravityMultiplier = 30000
var aimMultiplier = 120
var resistance = 0.4
var aiming = true
var maxAimDistance = 150
var stopBouncingThreshold = 5
var angularVelocityMulOnBounce = 0.6

func _process(_delta):
	if aiming:
		constant_force = Vector2(0, 0)
		handleAim()
	else:
		var force = calcForce() * gravityMultiplier
		force += drag()
		constant_force = force

func calcForce():
	if (aiming):
		return Vector2(0, 0)
	var sum = Vector2(0, 0)
	for planet in PlanetTracker.planets:
		var offset = planet.global_position - self.global_position
		var dist_sqr = offset.length_squared()
		var direction = offset.normalized()
		var force = direction * planet.mass / dist_sqr
		sum += force
	return sum

func drag():
	return -linear_velocity * resistance

func _input(event):
	if !aiming:
		return
	if event is InputEventMouseButton:
		var clickPos = get_local_mouse_position() + position
		var offset = (clickPos - self.global_position).limit_length(maxAimDistance)
		var speed = pow(offset.length(), 0.5) * aimMultiplier
		shoot(offset.normalized() * speed)

func _on_body_entered(body: Node) -> void:
	var norm: Vector2 = (position - body.position).normalized()
	var projection = linear_velocity.dot(norm) * norm
	if projection.length_squared() < stopBouncingThreshold * stopBouncingThreshold:
		beginAim()
	else:
		angular_velocity *= angularVelocityMulOnBounce

func beginAim():
	aiming = true
	set_deferred("freeze", true)
	linear_velocity = Vector2(0,0)
	angular_velocity = 0
	rotation_degrees = 0
	get_parent().get_node("Aimer").set_visible(true)

func shoot(vel: Vector2):
	aiming = false
	set_deferred("freeze", false)
	get_parent().get_node("Aimer").set_visible(false)
	set_deferred("linear_velocity", vel)
	set_deferred("angular_velocity", randf_range(-20, 20))

func handleAim():
	var aimer = get_parent().get_node("Aimer")
	var mouseposition = get_local_mouse_position() + position
	var offset = (mouseposition - position).limit_length(maxAimDistance)
	aimer.position = offset + position
