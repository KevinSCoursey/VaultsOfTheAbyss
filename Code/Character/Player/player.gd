extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
# Step height in pixels
const STEP_HEIGHT = 5
# Nodes to get at runtime:
@onready var animation_player := $AnimationPlayer
@onready var animated_sprite_2d := $AnimatedSprite2D
# Get the auto-loaded resource UserInputConstants from the scene root. This is a constant,
# but cannot be assigned at runtime if it is defined as a const.
@onready var USER_INPUT := $"/root/UserInputConstants"
# Get the GRAVITY from the project settings. This is a constant, but cannot be assigned at runtime
# if it is defined as a const.
@onready var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready():
	pass

func _physics_process(delta):
	# Add the GRAVITY, but only if the player is in the air.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed(USER_INPUT.JUMP) and is_on_floor():
		animation_player.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(USER_INPUT.MOVE_LEFT, USER_INPUT.MOVE_RIGHT)
	if direction:
		if velocity.y == 0:
			animation_player.play("run")
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = direction < 0
	else:
		if velocity.y == 0:
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.y > 0 and not is_on_floor():
		animation_player.play("fall")
	move_and_slide()
