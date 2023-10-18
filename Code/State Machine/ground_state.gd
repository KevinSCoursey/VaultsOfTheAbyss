class_name GroundState extends State

# Gets the air state from the parent state machine
@onready var air_state : State = get_parent().find_child("Air")

func on_enter_state():
	playback.travel("move")

func state_physics_process(delta):
	if !character.is_on_floor() && character.velocity.y >= character.step_height * 40:
		# If the character is in the air, transition to the air state. This can happen if they
		# fall off of a ledge, for example. Giving a falling buffer of a little bit of velocity
		# prevents an odd run-fall-run animation cycle when going down large-stepped stairs.
		next_state = air_state
		# Because they entered the air state without jumping, give them one extra multi-jump.
		next_state.multi_jumps_used -= 1
		playback.travel("fall from ledge")
	elif !character.is_on_floor():
		# If the character is in the air, apply some gravity to it.
		# We get here by the character being in the air but not by enough to exceed step height
		# Applying 75% of gravity to the player gives it a nice feel
		character.velocity.y += character.GRAVITY * 1.5 * delta

func state_input(event : InputEvent):
	# Handles player inputs
	if event.is_action_pressed("jump"):
		jump()

func jump():
	if character.is_on_floor():
		# Allows the jump to occur if the player is on the ground. Jump is implemented
		# by applying vertical (y) velocity and also setting the next state to be air
		character.velocity.y = character.jump_velocity
		next_state = air_state
		playback.travel("jump")
