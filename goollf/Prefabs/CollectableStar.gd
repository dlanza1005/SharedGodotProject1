extends Area2D
class_name CollectableStar

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func collect() -> void:
	$AnimationPlayer.play("collect")
