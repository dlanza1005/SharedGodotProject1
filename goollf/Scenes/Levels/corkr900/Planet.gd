extends StaticBody2D

@export var mass := 1000

func _ready():
	PlanetTracker.track(self)
