extends PlayerState

@export var jump_cooldown: float = .2
@export var gravity: float = .98
@export var max_terminal_velocity: float = 50
@export var max_jumps: int = 2

@export var air_speed: float = 8
@export var air_acceleration: float = 10
@export var cam_follow_speed: float = 8
@export var turn_speed: float = 10

var _jump_count: int = 0
var _jump_cooldown_remaining: float = 0


func enter():
	pass # Replace with function body.

func process(delta):
	_jump_cooldown_remaining = max(_jump_cooldown_remaining - delta, 0)
	
	if player.controls.is_jumping() && can_jump() && player.is_on_floor():
		state_machine.transition_to("InAir/Jumping")

func physics_process(delta):
	if player.is_on_floor():
		var state_name: String = "%s" % [state_machine._state.get_path()]
		if state_name.ends_with("Falling"):
			_jump_count = 0
			_jump_cooldown_remaining = 0
		state_machine.transition_to("OnGround")
		return
	
	set_horizontal_movement(air_speed, turn_speed, cam_follow_speed, air_acceleration, delta)
	
	player.y_velocity = clamp(player.y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

func can_jump():
	return player.is_on_floor() || (_jump_count < max_jumps && _jump_cooldown_remaining <= 0)

func accept_jump():
	_jump_count += 1
	_jump_cooldown_remaining = jump_cooldown
