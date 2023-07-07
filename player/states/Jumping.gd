extends PlayerState

@export var jump_force: float = 16

var _will_jump: bool = false

func enter():
	_will_jump = true
	
	parent.accept_jump()

func physics_process(delta):
	super.physics_process(delta)
	
	if !_will_jump:
		state_machine.transition_to("InAir/Falling")
		return
	
	_will_jump = false
	
	player.y_velocity = jump_force
	state_machine.transition_to("InAir/Falling")
