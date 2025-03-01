extends Node

var planets: Array[Planet] = []

func _init() -> void:
	planets = []

func track(planet: Planet) -> void:
	planets.push_back(planet)

func untrack(planet: Planet) -> void:
	var loc: int = planets.find(planet)
	if loc >= 0:
		planets.remove_at(loc)
