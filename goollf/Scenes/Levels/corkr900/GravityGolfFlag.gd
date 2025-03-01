extends Sprite2D
class_name GravityGolfFlag

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is GravityGolfBall:
		GameState.level_completed()
	pass # Replace with function body.
