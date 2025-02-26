extends Node

enum LevelState {
	Active = 0,
	Paused = 1,
	LevelIntro = 2,
	LevelComplete = 3,
}

var _level_state: LevelState = LevelState.Active
var _level_controller: LevelController = null

func begin_level(controller: LevelController) -> void:
	_level_state = LevelState.LevelIntro
	_level_controller = controller
	_level_controller.level_info_dialog.visibility_changed.connect(_on_level_info_visibility_changed)

func _on_level_info_visibility_changed():
	if _level_state == LevelState.LevelIntro && !_level_controller.level_info_dialog.visible:
		set_level_state(LevelState.Active)

func level_completed() -> void:
	set_level_state(LevelState.LevelComplete)

func set_level_state(state: LevelState) -> void:
	#TODO state change handling
	#if _level_state == LevelState.LevelIntro && _level_controller != null:
		#_level_controller.level_info_dialog.set_visible(false)
	_level_state = state

func get_level_state() -> LevelState:
	return _level_state

# Returns true if level was paused or
# false if the game can't be paused in its current state
func pause() -> bool:
	#TODO handle level state shenanigans
	var tree: SceneTree = get_tree()
	tree.paused = true
	return true

func unpause() -> void:
	#TODO handle level state shenanigans
	var tree: SceneTree = get_tree()
	tree.paused = false
