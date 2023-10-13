extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animation_player := $AnimationPlayer
@onready var animated_sprite_2d := $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation_player.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
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
