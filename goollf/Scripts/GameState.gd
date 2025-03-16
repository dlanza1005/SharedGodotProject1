extends Node

## Enumerates the possible level states
enum LevelState {
	Initial = 0,
	LevelIntro = 1,
	Active = 2,
	LevelComplete = 3,
	Unloading = 4
}

## Internal. Do not reference directly from other scripts.
var _level_state: LevelState = LevelState.Initial
## Internal. Do not reference directly from other scripts.
var _level_controller: LevelController = null

## Call this when a level is loaded
func begin_level(controller: LevelController) -> void:
	_level_controller = controller
	if _level_controller.level_info_dialog != null:
		_set_level_state(LevelState.LevelIntro)
		_level_controller.level_info_dialog.visibility_changed.connect(_on_level_info_visibility_changed)
	else:
		_set_level_state(LevelState.Active)
	_level_controller.fire_level_begin()

## Call this to notify the controller that the level is completed
func level_completed() -> void:
	_set_level_state(LevelState.LevelComplete)

## Get the level state
func get_level_state() -> LevelState:
	return _level_state

## Ask to pause the game.
## Returns true if level was paused or false if the game can't be paused in its current state.
func pause() -> bool:
	if _level_state != LevelState.Active:
		return false # Can't pause/unpause in level intro or level complete
	var tree: SceneTree = get_tree()
	tree.paused = true
	return true

## Ask to unpause the game.
## Returns true if level was unpaused or false if the game can't be unpaused in its current state.
func unpause() -> bool:
	if _level_state != LevelState.Active:
		return false # Can't pause/unpause in level intro or level complete
	var tree: SceneTree = get_tree()
	tree.paused = false
	return true

func load_next_or_return() -> void:
	# TODO go directly to the next level, if there is one
	get_tree().paused = false
	MainMenu.load_main_menu(self, MainMenu.MenuState.LevelSelect)

# ========================================
# private functions
# ========================================

## This is called when the level info node changes visibility.
## If we're in level intro state and the node was made not visible,
## change the state to Active.
func _on_level_info_visibility_changed():
	if _level_state == LevelState.LevelIntro && !_level_controller.level_info_dialog.is_visible_in_tree():
		_set_level_state(LevelState.Active)

## Just a helper function to wrap the null check to simplify the code
func _set_vis(node: Node, val: bool) -> void:
	if node != null:
		node.set_visible(val)

## Call this when level state changes
## This handles the bulk of the level state logic
## And runs any code that needs to happen on state change
func _set_level_state(new_state: LevelState) -> void:
	var tree: SceneTree = get_tree()
	if new_state == _level_state:
		return
	
	if _level_state == LevelState.Initial:
		# Initial state setup
		_set_vis(_level_controller.level_info_dialog, false)
		_set_vis(_level_controller.level_complete_dialog, false)
	
	if _level_state == LevelState.LevelIntro:
		# Exited level intro
		_set_vis(_level_controller.level_info_dialog, false)
	
	if new_state == LevelState.LevelIntro:
		_set_vis(_level_controller.level_info_dialog, true)
	
	if new_state == LevelState.Active:
		_level_controller.fire_level_active()
	
	if new_state == LevelState.LevelComplete:
		_set_vis(_level_controller.level_complete_dialog, true)
		tree.paused = _level_controller.pause_on_level_complete
		_level_controller.fire_level_complete()
		# TODO mark level complete in save data
		SaveFile.save_current()
	
	_level_state = new_state
