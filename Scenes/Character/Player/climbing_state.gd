class_name ClimbingState extends State

func on_enter_state():
	playback.travel("climb")

func state_physics_process(delta):
	if !character.is_on_floor() && character.velocity.y >= character.step_height * 40:
		# If the character is in the air, transition to the air state. This can happen if they
		# fall off of a ledge, for example. Giving a falling buffer of a little bit of velocity
		# prevents an odd run-fall-run animation cycle when going down large-stepped stairs.
		next_state = air_state
		# Because they entered the air state without jumping, give them one extra multi-jump.
		next_state.multi_jumps_used -= 1
		playback.travel("fall from ledge")
	
	if character.climbing_region_count < 1:
		next_state = ground_state
	
func move(direction : Vector2, _delta):
	# Handles Left/Right motion. The float is the speed multiplier.
	move_left_right(direction, 0.125)
	
	# Handle Up/Down motion
	if direction.y != 0:
		# If the player is moving up or down, set the time scale to 1 for the animation and
		# apply that motion
		character.animation_tree.set("parameters/climb/TimeScale/scale", 1)
		character.velocity.y = direction.y * character.climb_speed
	else:
		# If the player isn't moving, set the time scale to 0 for the animation, effectively
		# pausing it, and set that motion to 0
		character.animation_tree.set("parameters/climb/TimeScale/scale", 0)
		character.velocity.y = 0
	
	flip_sprite_to_direction(direction)
