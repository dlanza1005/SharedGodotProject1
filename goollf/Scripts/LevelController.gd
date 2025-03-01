extends Node2D
class_name LevelController

@export var level_info_dialog: CanvasItem = null
@export var level_complete_dialog: CanvasItem = null
@export var pause_on_level_complete: bool = true

## This signal fires when the level has been registered (loaded).
## This may fire before all nodes are loaded unless this script is on the scene's root node.
signal level_begin
## This signal fires when the level info dialog is closed and the level becomes active
signal level_active
## This signal fires after the level is marked as complete, and before save data is saved
signal level_complete
## This signal fires when the level is about to be unregistered (unloaded)
signal level_unload

func _ready() -> void:
	GameState.begin_level(self)

func fire_level_begin():
	level_begin.emit()

func fire_level_active():
	level_active.emit()

func fire_level_complete():
	level_complete.emit()

func fire_level_unload():
	level_unload.emit()
