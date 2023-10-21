class_name GroundState extends State

func on_enter_state():
	playback.travel("move")

func state_physics_process(delta):
	check_if_trying_to_climb()
	
	if character.is_on_floor() or character.climbing_region_count > 0:
		# Don't bother with the rest of the code if the player is on the ground already
		# or they are standing infront of at least one climbing region.
		# Writing it this way simplifies the subsequent if/else statements.
		character.velocity.y = 0
		return
	elif character.velocity.y >= character.step_height * 40:
		# If the character is in the air, transition to the air state. This can happen if they
		# fall off of a ledge, for example. Giving a falling buffer of a little bit of velocity
		# prevents an odd run-fall-run animation cycle when going down large-stepped stairs.
		next_state = air_state
		# Because they entered the air state without jumping, give them one extra multi-jump.
		next_state.multi_jumps_used -= 1
		playback.travel("fall from ledge")
	else:
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
		
func melee_attack():
	# Displays the melee attack animation and makes the character face the side of the screen that
	# the mouse was clicked on
	character.sprite_2d.flip_h = is_mouse_right_of_player()
	playback.travel("melee-swing")
