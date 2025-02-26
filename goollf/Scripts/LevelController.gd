extends Node2D
class_name LevelController

@export var level_info_dialog: CanvasItem = null
@export var level_complete_dialog: CanvasItem = null

func _ready() -> void:
	GameState.begin_level(self)
