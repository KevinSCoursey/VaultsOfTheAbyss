class_name AirState extends State

# Gets the ground state from the parent state machine
@onready var ground_state : State = get_parent().find_child("Ground")
# State behavior tracking
var multi_jumps_used := 0

func state_physics_process(delta):
	if character.is_on_floor():
		# If the player has touched the ground, then transition to the ground state
		next_state = ground_state
	else:
		# If the character is in the air, apply some gravity to it.
		# Applying 75% of gravity to the player gives it a nice feel
		character.velocity.y += character.GRAVITY * 1.5 * delta

func state_input(event : InputEvent):
	# Handles player inputs
	if event.is_action_pressed("jump"):
		jump()

func jump():
	if multi_jumps_used < character.multi_jumps_max:
		# Allows the player to jump if already in the air as long as their used
		# multi-jumps hasn't reached the max multi-jumps allowed. If they do perform
		# a multi-jump, add the applicable vertical velocity and increment the multi-jumps
		# used by one.
		multi_jumps_used += 1
		character.velocity.y = character.jump_velocity
		playback.travel("flip")

func on_exit_state():
	if next_state == ground_state:
		# If the next state is the ground, reset the multi-jump counter. We don't want to reset
		# this every time we leave this state because we could make things messy with air attack
		# states for example.
		multi_jumps_used = 0
