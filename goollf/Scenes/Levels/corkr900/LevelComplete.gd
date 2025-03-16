extends PanelContainer

@export var continue_button: Button

func _on_okay_pressed() -> void:
	GameState.load_next_or_return()
