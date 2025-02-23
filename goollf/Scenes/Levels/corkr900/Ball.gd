extends RigidBody2D

var gravityMultiplier = 20000
var resistance = 0.4
var aiming = true

func _ready():
	# TODO
	pass

func _process(_delta):
	if aiming:
		constant_force = Vector2(0, 0)
		handleAim()
	else:
		var force = calcForce() * gravityMultiplier
		force += drag()
		constant_force = force
	pass

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
	if event is InputEventMouseButton:
		aiming = false
		get_parent().get_node("Aimer").set_visible(false)
		var offset = event.global_position - self.global_position
		var impulse = pow(offset.length(), 0.5) * 25
		apply_impulse(offset.normalized() * impulse)

func _on_body_entered(_body: Node) -> void:
	aiming = true
	get_parent().get_node("Aimer").set_visible(true)
	linear_velocity = Vector2(0,0)
	angular_velocity = 0

func handleAim():
	var aimer = get_parent().get_node("Aimer")
	var mouseposition = get_viewport().get_mouse_position()
	var offset = (mouseposition - position).limit_length(150)
	aimer.position = offset + position
