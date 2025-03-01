extends Node

# The data that gets loaded & saved.
# To add more, make the var here, and add its handling to
# _get_data(), _apply_data(), and _apply_new_data()
var display_name: String
var slot: int

## This function returns the save data as a Dictionary so it can be serialized
func _get_data() -> Dictionary:
	# Return the save data as a dictionary so it can be serialized
	return {
		"display_name": display_name
	}

## This function populates the SaveFile variables from a loaded dictionary
func _apply_data(data: Dictionary) -> void:
	# Apply loaded data to this object
	display_name = data["display_name"]

## This function populates the default values for all variables when creating a new savefile
func _apply_new_data() -> void:
	# Apply default values for a new savefile
	display_name = "Pro Goollfer"

# #################################################
# ### Don't need to modify anything below here. ###
# #################################################

func load_or_create(slot_to_load: int) -> void:
	if LoadSave.save_file_exists(slot_to_load):
		load_slot(slot_to_load)
	else:
		create_new_at(slot_to_load)

func create_new_at(slot_to_make: int) -> int:
	_apply_new_data()
	slot = slot_to_make
	return slot_to_make

func create_new() -> int:
	return create_new_at(LoadSave.find_unused_save_slot())

func load_slot(slot_to_load: int) -> bool:
	var data = LoadSave.load(slot_to_load)
	if data["failed_to_load"] == true:
		return false
	slot = slot_to_load
	_apply_data(data)
	return true

func save_slot(slot_to_save) -> void:
	var data_dict = _get_data()
	LoadSave.save(data_dict, slot_to_save)

func save_current() -> void:
	save_slot(slot)
	
func _enter_tree() -> void:
	load_or_create(0) # TODO: UI for loading saves

func _exit_tree() -> void:
	save_current()
