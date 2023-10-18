extends Label

# Get the state machine
@onready var state_machine : CharacterStateMachine = get_parent().find_child("CharacterStateMachine")

func _process(_delta):
	# Sets the label text to the current state every frame
	text = "State: " + state_machine.current_state.name
