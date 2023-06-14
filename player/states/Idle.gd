extends State

class_name IdleState

@export var jump_velocity = 5
@export var jump_state : State
@export var interact_state : State
@export var run_state : State

func state_input(event : InputEvent):
	if event.is_action_pressed("jump") and character.is_on_floor():
		jump()
	if event.is_action_pressed("interact") and !character.has_movement():
		interact()
	if event.is_action_pressed("sprint"):
		run()

func jump():
	character.velocity.y = jump_velocity
	next_state = jump_state

func interact():
	next_state = interact_state

func run():
	next_state = run_state
