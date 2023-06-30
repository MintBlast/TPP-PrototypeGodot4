extends PlayerState

@export var move_speed: float = 10
@export var sprint_speed: float = 14
@export var turn_speed: float = 10
@export var acceleration: float = 50
@export var cam_follow_speed: float = 8

func physics_process(delta):
	super.physics_process(delta)
	
	var speed = sprint_speed if player.controls.is_sprinting() else move_speed
	set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta)
	
	if player.is_on_floor():
		player.y_velocity = -0.01
	else:
		state_machine.transition_to("InAir/Falling")
