extends CharacterBody2D

# Important note: The scale of the player is 2! This means that the normal things like gravity
# doubled

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
# Step height in pixels
const STEP_HEIGHT = 10
# Nodes to get at runtime:
@onready var animation_player := $AnimationPlayer
@onready var animated_sprite_2d := $AnimatedSprite2D
@onready var animation_tree := $AnimationTree
# Get the auto-loaded resource UserInputConstants from the scene root. This is a constant,
# but cannot be assigned at runtime if it is defined as a const.
@onready var USER_INPUT := $"/root/UserInputConstants"
# Get the GRAVITY from the project settings. This is a constant, but cannot be assigned at runtime
# if it is defined as a const.
@onready var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") as float
# Get the front and back 2D raycasts. This basically lets you determine the platform angle
@onready var raycast2d_front := $"RayCast2D Front"
@onready var raycast2d_back := $"RayCast2D Back"
# Controls the number of multi-jumps the player has available
var double_jumps_max := 2
var double_jumps_used := 0
# Parameters used to track the states/properties of the player
var is_melee_attacking = false
var is_running = false
var is_jumping = false
var is_multi_jumping = false

func _ready():
	animation_tree.active = true
	position_raycasts()

func _process(_delta):
	pass
	# update_animation_parameters()

func _physics_process(delta):
	# Add the GRAVITY, but only if the player is in the air.
	if not is_on_floor():
		# Applying 75% of gravity to the player gives it a nice feel
		velocity.y += GRAVITY * 1.5 * delta
	else:
		double_jumps_used = 0

	# Allow the player to jump if they are either on the floor or have not yet used all
	# of their available double jumps.
	if Input.is_action_just_pressed(USER_INPUT.JUMP) and \
	(is_on_floor() or double_jumps_used < double_jumps_max):
		# If this is the first jump, use the jump animation.
		# Otherwise, it is a multi-jump, and should use that animation instead.
		if double_jumps_used == 0:
			$AnimationTree.get("parameters/playback").travel("jump")
		else:
			$AnimationTree.get("parameters/playback").travel("multi-jump")
		velocity.y = JUMP_VELOCITY
		double_jumps_used += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(USER_INPUT.MOVE_LEFT, USER_INPUT.MOVE_RIGHT)
	if direction:
		if velocity.y == 0:
			$AnimationTree.get("parameters/playback").travel("run")
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = direction < 0
	else:
		if velocity.y == 0 and is_on_floor():
			$AnimationTree.get("parameters/playback").travel("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.y > 0 and not is_on_floor():
		$AnimationTree.get("parameters/playback").travel("fall")
	move_and_slide()
	
func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		# Makes the player look in the direction that the mouse was clicked for an attack
		animated_sprite_2d.flip_h = not is_mouse_right_of_player()
		# Play the appropriate attack animation depending on if the player is on the ground or not
		if is_on_floor():
			$AnimationTree.get("parameters/playback").travel("melee-attack-ground")
		else:
			$AnimationTree.get("parameters/playback").travel("melee-attack-air")

func update_animation_parameters():
	animation_tree["parameters/conditions/is_melee_attacking"] = is_melee_attacking
	animation_tree["parameters/conditions/is_jumping"] = is_jumping
	animation_tree["parameters/conditions/is_running"] = is_running
	animation_tree["parameters/conditions/is_on_floor"] = is_on_floor()
	
func is_mouse_right_of_player():
	# Checks if the position of the mouse is to the right of the player
	return get_global_mouse_position().x >= transform.origin.x

func position_raycasts():
	# Gets the CollisionShape2D's height (y)
	var collision_shape_height = $CollisionShape2D.shape.size.y
	# Positions the RayCast2Ds to function as "feet"
	raycast2d_front.transform.origin = Vector2(STEP_HEIGHT, 0.5 * collision_shape_height - STEP_HEIGHT + 2)
	raycast2d_back.transform.origin = Vector2(-STEP_HEIGHT, 0.5 * collision_shape_height - STEP_HEIGHT + 2)
	
