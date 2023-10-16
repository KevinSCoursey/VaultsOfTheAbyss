extends Camera2D

var CAMERA_SENSITIVITY := 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin = Vector2(lerpf(transform.origin.x, get_parent().transform.origin.x, delta * CAMERA_SENSITIVITY), lerpf(transform.origin.y, get_parent().transform.origin.y, delta * CAMERA_SENSITIVITY))
