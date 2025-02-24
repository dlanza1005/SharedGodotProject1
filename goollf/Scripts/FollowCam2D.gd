extends Camera2D

@export var follow_node: Node = null

func _process(_delta):
	if follow_node != null:
		global_position = follow_node.global_position # TODO: add smoothing
	
