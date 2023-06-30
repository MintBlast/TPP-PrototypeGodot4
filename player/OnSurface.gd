extends PlayerState

@export var swim_speed: float = 4
@export var turn_speed: float = 2
@export var acceleration: float = 10
@export var cam_follow_speed: float = 4
@export var jump_power: float = 30

func physics_process(delta):
	super.physics_process(delta)
	
	set_horizontal_movement(swim_speed, turn_speed, cam_follow_speed, acceleration, delta)
	
	if player.controls.is_jumping():
		player.y_velocity = jump_power
	else:
		player.y_velocity = lerpf(player.y_velocity, 0, acceleration * delta)
