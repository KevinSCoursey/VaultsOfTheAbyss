class_name State extends Node

var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State
# State behaviors
@export var can_move := true

func on_enter_state():
	# Default function for entering the state
	pass

func state_physics_process(_delta):
	# Default function for handling physics process
	pass

func state_input(_event : InputEvent):
	# Default function for recieving input
	pass

func move(direction : Vector2, _delta):
	# This is the generic motion behavior for all states.
	if direction.x != 0 and can_move:
		# Applies movement in the left/right direction if a left/right input is recieved
		# and the current character state machine state allows motion
		character.velocity.x = direction.x * character.speed
		character.sprite_2d.flip_h = direction.x < 0
	else:
		# Applies the velocity without a y component for the x
		character.velocity.x = move_toward(character.velocity.x, 0, character.speed)

func jump():
	# Default jump function
	pass
	
func melee_attack():
	# Defuault melee attack function
	pass

func on_exit_state():
	# Default function for exiting the state
	pass

func is_mouse_right_of_player():
	# Checks if the position of the mouse is to the right of the player
	return character.get_global_mouse_position().x <= character.transform.origin.x
