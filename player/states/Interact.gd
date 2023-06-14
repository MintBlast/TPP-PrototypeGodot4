extends State

@export var idle_state : State

func state_input(event : InputEvent):
	if event.is_action_pressed("uninteract"):
		leave()

func leave():
	next_state = idle_state
