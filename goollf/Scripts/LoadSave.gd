extends Node

# TODO: Meta save file for metadata about all the files
# TODO: Multiple save file support

## Gets the file path to use for the given save slot
func get_file_path(slot: int) -> String:
	return "user://save_slot_%s.save" % slot

## Gets the maximum allowable number of save slots
func get_max_saves() -> int:
	return 1

## Finds a slot for a new savefile
func find_unused_save_slot() -> int:
	return 0 

## Gets an array of all the slots that have a savefile
func get_all_available_saves() -> Array[int]:
	var arr = []
	for slot in get_max_saves():
		if save_file_exists(slot):
			arr.push_back(slot)
	return arr

## Determines whether a save file exists in the given slot
func save_file_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_file_path(slot))

## Deletes a savefile from the given slot if it exists
func delete(slot: int) -> void:
	var path: String = get_file_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

## Loads data from the given slot
func load(slot: int) -> Dictionary:
	var path: String = get_file_path(slot)
	if not FileAccess.file_exists(get_file_path(slot)):
		print("Save file does not exist!")
		return { "failed_to_load": true }
	
	var save_file = FileAccess.open(path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string: String = save_file.get_line()
		var json = JSON.new()
		if not json.parse(json_string) == OK:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
			continue
		var json_data: Dictionary = json.get_data()
		return json_data
	return { "failed_to_load": true }

## Saves data to the given slot
func save(data: Dictionary, slot: int) -> bool:
	var save_file = FileAccess.open(get_file_path(slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(data))
	return false
