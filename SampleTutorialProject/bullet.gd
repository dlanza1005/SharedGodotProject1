extends Area2D

var travel_distance = 0

func _physics_process(delta):
	const SPEED = 1000.0
	const RANGE = 2000
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travel_distance += SPEED*delta
	if travel_distance > RANGE:
		queue_free()
	
	


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
