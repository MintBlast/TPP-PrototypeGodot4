extends Node

class_name StateMachine

signal transitioned(state_path)

@export var character : CharacterBody3D
@export var current_state : State

var states : Array[State]

# Called when the node enters the scene tree for the first time.
func _ready():
	# check and set the statemachine's children
	for child in get_children():
		# if the children are states
		if (child is State):
			# add them
			states.append(child)
			# each child is connected to the character controller
			child.character = character
		else:
			# shows a warning if the child is not a state
			push_warning("Child " + child.name + " is not a State")

func check_if_can_move():
	return current_state.can_move

# always check the state every delta time
func _physics_process(delta):
	if current_state.next_state != null:
		switch_state(current_state)
	
	current_state.state_process(delta)

func switch_state(new_state : State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	
	current_state.on_enter()

func _input(event : InputEvent):
	current_state.state_input(event)
