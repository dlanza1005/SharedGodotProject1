extends Control
class_name MainMenu

enum MenuState {
	Title,
	Main,
	Settings,
	Credits,
	FileSelect,
	LevelSelect,
}

@export var title : Control
@export var menu : Control
@export var settings : Control
@export var credits : Control
@export var fileSelect : Control
@export var levelSelect : Control

static var state = MenuState.Title

static func set_starting_state(starting_state: MenuState) -> void:
	state = starting_state

static func load_main_menu(node: Node, starting_state: MenuState) -> void:
	set_starting_state(starting_state)
	node.get_tree().change_scene_to_file("res://Scenes/General/MainMenu.tscn")

func _ready() -> void:
	_apply_node_visibility()

## Goes to the given menu
## Returns true if change is successful or false if it couldn't change
func go_to(newstate: MenuState) -> bool:
	if (newstate == state):
		return false
	state = newstate
	_apply_node_visibility()
	return true

# ###########################################

func _apply_node_visibility() -> void:
	# TODO fun lil animations for changing menus
	set_vis(title, state == MenuState.Title)
	set_vis(menu, state == MenuState.Main)
	set_vis(settings, state == MenuState.Settings)
	set_vis(credits, state == MenuState.Credits)
	set_vis(fileSelect, state == MenuState.FileSelect)
	set_vis(levelSelect, state == MenuState.LevelSelect)

func set_vis(ctrl : Control, vis : bool) -> void:
	if(vis):
		ctrl.show()
	else:
		ctrl.hide()

# ###########################################

func _input(event: InputEvent) -> void:
	if state == MenuState.Title and event.is_released() and (event is InputEventKey or event is InputEventMouseButton):
		go_to(MenuState.Main)

func _on_new_game_pressed() -> void:
	SaveFile.create_new()
	go_to(MenuState.LevelSelect)

func _on_load_game_pressed() -> void:
	go_to(MenuState.FileSelect)

func _on_settings_pressed() -> void:
	go_to(MenuState.Settings)

func _on_credits_pressed() -> void:
	go_to(MenuState.Credits)

func _on_level_selected(level: String) -> void:
	if level == "gravity_golf":
		get_tree().change_scene_to_file("res://Scenes/Levels/corkr900/GravityGolf.tscn")
	if level == "object_golf":
		get_tree().change_scene_to_file("res://Scenes/Levels/MuggleDave23/object_golf.tscn")

func _on_return_to_main_menu() -> void:
	go_to(MenuState.Main)
