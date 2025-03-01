extends RigidBody2D
class_name GravityGolfBall

var gravityMultiplier: float = 30000
var aimMultiplier: float = 120
var resistance: float = 0.4
var aiming: bool = false
var maxAimDistance: float = 150
var stopBouncingThreshold: float = 5
var angularVelocityMulOnBounce: float = 0.6

var level_is_active: bool = false

func _process(_delta) -> void:
	if not level_is_active:
		return
	if aiming:
		constant_force = Vector2(0, 0)
		handleAim()
	else:
		var force = calcForce() * gravityMultiplier
		force += drag()
		constant_force = force

func calcForce() -> Vector2:
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

func drag() -> Vector2:
	return -linear_velocity * resistance

func _input(event) -> void:
	if not level_is_active or not aiming:
		return
	if event is InputEventMouseButton:
		var clickPos = get_local_mouse_position() + position
		var offset = (clickPos - self.global_position).limit_length(maxAimDistance)
		var speed = pow(offset.length(), 0.5) * aimMultiplier
		shoot(offset.normalized() * speed)

func _on_body_entered(body: Node) -> void:
	if not level_is_active:
		return
	var norm: Vector2 = (position - body.position).normalized()
	var projection = linear_velocity.dot(norm) * norm
	if projection.length_squared() < stopBouncingThreshold * stopBouncingThreshold:
		beginAim()
	else:
		angular_velocity *= angularVelocityMulOnBounce

func beginAim() -> void:
	aiming = true
	set_deferred("freeze", true)
	linear_velocity = Vector2(0,0)
	angular_velocity = 0
	rotation_degrees = 0
	get_parent().get_node("Aimer").set_visible(true)

func shoot(vel: Vector2) -> void:
	aiming = false
	set_deferred("freeze", false)
	get_parent().get_node("Aimer").set_visible(false)
	set_deferred("linear_velocity", vel)
	set_deferred("angular_velocity", randf_range(-20, 20))

func handleAim() -> void:
	var aimer = get_parent().get_node("Aimer")
	var mouseposition = get_local_mouse_position() + position
	var offset = (mouseposition - position).limit_length(maxAimDistance)
	aimer.position = offset + position

func _on_gravity_golf_level_active() -> void:
	level_is_active = true
	beginAim()
