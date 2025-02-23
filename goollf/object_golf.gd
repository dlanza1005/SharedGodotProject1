extends Node2D
## plan for this level:
# the screen (golf hole) will have the hole marked.
#	the screen will possibly have other rigid body obstacles present at the start.
# top right of the screen has a list of your objects. you need to hit these objects 
#	with the pool cue or golf club. they are rigid bodies that the ball will 
#	interact with the ball.
# the last object to be hit is the ball itself. the ball must go into the hole in one shot.
# the difficulty is:
#	-hitting the objects accurately enough that they land in the right spot and 
#	 right orientation to help redirect the ball on the final shot
#	-hitting the objects so that they are not in your way; each object has to
#	 be hit onto the field, so if theres something inconvenient, you need to
#	 plan your shots so that you can still get the ball in the hole.
#	-hitting the ball accurately enough to go in the hole

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
