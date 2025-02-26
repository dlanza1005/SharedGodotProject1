extends Node

var planets: Array[Planet] = []

func _init() -> void:
	planets = []
	print("initializing planets tracker")

func track(planet: Planet) -> void:
	planets.push_back(planet)
