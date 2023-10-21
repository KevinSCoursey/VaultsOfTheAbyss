extends Node2D

@onready var character : Player = get_parent()
@onready var raycast2d_front : RayCast2D = character.find_child("RayCast2D Front")
@onready var raycast2d_back : RayCast2D = character.find_child("RayCast2D Back")

var drawing_raycast2d_front = false
var drawing_raycast2d_back = false

func _process(_delta):
	queue_redraw()

func _draw():
	if drawing_raycast2d_front:
		draw_line(character.global_transform.origin + 2 * Vector2(0, character.collision_shape_height), \
		Vector2(raycast2d_front.global_transform.origin.x + raycast2d_front.target_position.x, \
		raycast2d_front.global_transform.origin.y + raycast2d_front.target_position.y), Color.RED, 1)
		print(character.global_transform.origin + 2 * Vector2(0, character.collision_shape_height), \
		raycast2d_front.get_collision_point())
		
	if drawing_raycast2d_back:
		draw_line(character.global_transform.origin + 2 * Vector2(0, character.collision_shape_height), \
		Vector2(raycast2d_back.global_transform.origin.x + raycast2d_back.target_position.x, \
		raycast2d_back.global_transform.origin.y + raycast2d_back.target_position.y), Color.RED, 1)
