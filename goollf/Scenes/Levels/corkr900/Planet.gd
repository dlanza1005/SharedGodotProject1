extends StaticBody2D
class_name Planet

@export var mass := 1000

func _enter_tree() -> void:
	PlanetTracker.track(self)

func _exit_tree() -> void:
	PlanetTracker.untrack(self)
