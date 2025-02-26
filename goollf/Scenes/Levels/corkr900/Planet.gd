extends StaticBody2D
class_name Planet

@export var mass := 1000

func _ready() -> void:
	PlanetTracker.track(self)
