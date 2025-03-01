extends Node2D

@export var max_pullback := 100.0  # Maximum pullback distance
@export var charge_speed := 200.0  # Speed of pullback increase
@export var hit_speed := 0.2       # Speed of the forward poke
@export var reset_speed := 0.3     # Speed to reset the cue

var pullback_distance := 0.0
var charging := false
var aiming := true  # True when adjusting angle, false during animation
#var cue_angle := 0.0  # angle of the cue

func _process(delta):
	if aiming:
		update_cue_angle()

	if charging:
		pullback_distance = min(pullback_distance + charge_speed * delta, max_pullback)
		position = Vector2(-pullback_distance * cos(rotation), -pullback_distance * sin(rotation))  # Move cue back

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_charging()
			else:
				release_shot()

func update_cue_angle():
	var mouse_position = get_global_mouse_position()
	var angle_to_mouse = (mouse_position - global_position).angle()
	rotation = angle_to_mouse

func start_charging():
	charging = true
	pullback_distance = 0.0

func release_shot():
	charging = false
	aiming = false  # Stop aiming when shooting

	var tween = create_tween()
	
	# Move the cue forward (STRIKE ANIMATION)
	tween.tween_property(self, "position", Vector2(10, 0), hit_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Apply force to ball when cue reaches peak (HALFWAY through animation)
	await get_tree().create_timer(hit_speed * 0.5).timeout  # Apply force at halfway point
	apply_force_to_ball()

	# Let follow-through happen, then reset cue
	await tween.finished
	reset_cue()


func apply_force_to_ball():
	var direction = Vector2.RIGHT.rotated(rotation)  # Forward direction
	var force = pullback_distance * 10  # Scale force based on pullback

	var ball = get_parent().get_node("Objects/Ball")
	if ball:
		ball.apply_impulse(direction * force)
	else:
		print("Error: Ball not found!")


func play_shot_animation():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(10, 0), hit_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await tween.finished  # Wait for the hit animation
	reset_cue()

func reset_cue():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, 0), reset_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	await tween.finished
	aiming = true  # Re-enable aiming
