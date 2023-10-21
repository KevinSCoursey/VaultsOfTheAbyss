extends Label

@onready var state_machine : CharacterStateMachine = get_parent().find_child("CharacterStateMachine")
@onready var player : Player = get_parent() as Player

func _process(_delta) -> void:
	# Sets the label text to the current state every frame
	text = "State: %s\nInput: (%s, %s)\nVelocity: X: %s Velocity: Y: %s\nClimbing region count: %s" % \
	[state_machine.current_state.name, \
	player.direction.x, player.direction.y, \
	player.velocity.x, player.velocity.y, \
	player.climbing_region_count]
