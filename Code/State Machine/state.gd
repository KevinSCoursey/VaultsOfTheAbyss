class_name State extends Node

# Gets the air state from the parent state machine
@onready var air_state : State = get_parent().find_child("Air")
@onready var ground_state : State = get_parent().find_child("Ground")
@onready var climbing_state : State = get_parent().find_child("Climbing")
# Player references
var character : Player
var next_state : State
var playback : AnimationNodeStateMachinePlayback
# State behaviors
@export var can_move := true

func on_enter_state() -> void:
	# Default function for entering the state
	pass

func state_physics_process(_delta) -> void:
	# Default function for handling physics process
	pass

func state_input(_event : InputEvent) -> void:
	# Default function for recieving input
	pass

func check_if_trying_to_climb() -> void:
	if character.direction.y != 0 and character.climbing_region_count > 0:
		# If the player is trying to move up or down, and they can climb, transition them
		# to the climbing state
		next_state = climbing_state

func move_left_right(direction : Vector2, x_speed_multiplier : float) -> void:
	# Handle Left/Right motion
	if direction.x != 0 and can_move:
		# Applies movement in the left/right direction if a left/right input is recieved
		# and the current character state machine state allows motion
		character.velocity.x = direction.x * character.speed * x_speed_multiplier
		if character.foot_collision:
			character.velocity.y -= direction.x * character.speed * x_speed_multiplier * 1.25
		character.sprite_2d.flip_h = direction.x < 0
	else:
		# Applies the velocity without a y component for the x
		character.velocity.x = move_toward(character.velocity.x, 0, character.speed)

func move(direction : Vector2, _delta) -> void:
	# Handles Left/Right motion. The float is the speed multiplier.
	# This is the generic motion behavior for all states.
	move_left_right(direction, 1)
	
	# Handle Up/Down motion
	if direction.y != 0 and character.climbing_region_count > 0:
		character.velocity.y += direction.y * character.climb_speed
	
	flip_sprite_to_direction(direction)

func jump() -> void:
	# Default jump function
	pass
	
func melee_attack() -> void:
	# Defuault melee attack function
	pass

func on_exit_state() -> void:
	# Default function for exiting the state
	pass

func is_mouse_right_of_player() -> bool:
	# Checks if the position of the mouse is to the right of the player
	return character.get_global_mouse_position().x <= character.transform.origin.x

func flip_sprite_to_direction(direction) -> void:
	# Applies the left/right motion to the movement animation
	character.animation_tree.set("parameters/move/blend_position", direction.x)
