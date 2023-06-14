extends State

class_name JumpState

@export var idle_state : State

func state_process(delta):
	if character.is_on_floor():
		next_state = idle_state
