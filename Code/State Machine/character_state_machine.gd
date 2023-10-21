class_name CharacterStateMachine extends Node

# Player component references
@onready var character : Player = get_parent()
@onready var animation_tree : AnimationTree = get_parent().find_child("AnimationTree")
# State handling
@export var current_state : State
var states : Array[State]

func _ready():
	for child in get_children():
		# Find all children that this state machine has
		if child is State:
			# Add all of the children which are states to our State array
			states.append(child)
			# Set up the children by provinding them the relavent information
			child.character = character
			child.playback = animation_tree["parameters/playback"]
		else:
			# Warn the user if there is somehow a child of the state machine that is not a State
			push_warning("Child " + child.name + " is not a State, but its parent is " + name + "!")

func _physics_process(delta):
	if current_state.next_state != null:
		# The next state will only be not null when a change of state is desired
		switch_states(current_state.next_state)
		
	if current_state != null:
		# Handles the current state's physics process
		current_state.state_physics_process(delta)

func _intput(event : InputEvent):
	# Provides the current state with the input event that has been given to the state machine
	current_state.state_input(event)

func switch_states(new_state : State):
	# Changes which state the state machine is in
	if current_state != null:
		# If the current state isn't null, then we want to perform its exit process
		current_state.on_exit_state()
	
	# Set the current state's next state to null so that it doesn't try to swap back immediately
	current_state.next_state = null
	current_state = new_state
	
	if current_state != null:
		# If the current state isn't null, then we want to perform its entry process
		current_state.on_enter_state()
		# Setting the next state to null prevents the state from trying to change immediately
		current_state.next_state = null

func check_if_can_move():
	# Simply returns if the current state has motion enabled
	return current_state.can_move
