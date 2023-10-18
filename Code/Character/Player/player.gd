extends CharacterBody2D
# Important note: The scale of the player is 2! This means that the normal things like gravity
# are doubled

# Player settings
var speed = 400.0
var jump_velocity = -600.0
var step_height = 10
# Controls the number of multi-jumps the player has available.
# Note: When jumping off the ground, the first jump is 'free' so a multi_jump max of 1
# would result in two total jumps before hitting the ground again
var multi_jumps_max := 1

# Nodes to get at runtime:
@onready var animation_tree := $AnimationTree
@onready var sprite_2d := $Sprite2D
# Get the auto-loaded resource UserInputConstants from the scene root. This is a constant,
# but cannot be assigned at runtime if it is defined as a const.
@onready var USER_INPUT := $"/root/UserInputConstants"
# Get the GRAVITY from the project settings. This is a constant, but cannot be assigned at runtime
# if it is defined as a const.
@onready var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") as float
# Get the front and back 2D raycasts. This basically lets you determine the platform angle
@onready var raycast2d_front := $"RayCast2D Front"
@onready var raycast2d_back := $"RayCast2D Back"

# Input tracking
var direction := Vector2(0, 0)

# State machine
@onready var state_machine := $CharacterStateMachine

func _ready():
	animation_tree.active = true
	# position_raycasts()

func _physics_process(delta):
	# Gets the user's input for the current frame regarding axis motion
	direction = Input.get_vector(USER_INPUT.MOVE_LEFT, USER_INPUT.MOVE_RIGHT, \
	USER_INPUT.MOVE_UP, USER_INPUT.MOVE_DOWN)
	
	if state_machine.current_state != null:
		# Allow the current state to handle motion
		state_machine.current_state.move(direction, delta)
		
	if state_machine.current_state != null and Input.is_action_just_pressed(USER_INPUT.JUMP):
		# Allow the current state to handle jumping
		state_machine.current_state.jump()
		
	move_and_slide()
	update_animation_parameters()
	
func _unhandled_input(event):
	if state_machine.current_state != null and event.is_action_pressed("attack"):
		# Allow the current state to handle attacking
		state_machine.current_state.melee_attack()

func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func position_raycasts():
	# Gets the CollisionShape2D's height (y)
	var collision_shape_height = $CollisionShape2D.shape.size.y
	# Positions the RayCast2Ds to function as "feet"
	raycast2d_front.transform.origin = Vector2(step_height, 0.5 * collision_shape_height - step_height + 2)
	raycast2d_back.transform.origin = Vector2(-step_height, 0.5 * collision_shape_height - step_height + 2)
	
