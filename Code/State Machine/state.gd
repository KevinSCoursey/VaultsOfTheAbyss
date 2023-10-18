class_name State extends Node

var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State
# State behaviors
@export var can_move := true

func state_physics_process(_delta):
	# Default function for handling physics process
	pass

func state_input(_event : InputEvent):
	# Default function for recieving input
	pass

func move(direction : Vector2, delta):
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

func on_exit_state():
	# Default function for exiting the state
	pass
	
func on_enter_state():
	# Default function for entering the state
	pass
