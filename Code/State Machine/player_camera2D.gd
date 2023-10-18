extends Camera2D

@export var CAMERA_SENSITIVITY := 5

func _process(delta):
	# Moves the cameras position smoothly to the parent's postion
	transform.origin = Vector2(\
	lerpf(transform.origin.x, get_parent().transform.origin.x, delta * CAMERA_SENSITIVITY), \
	lerpf(transform.origin.y, get_parent().transform.origin.y, delta * CAMERA_SENSITIVITY))
