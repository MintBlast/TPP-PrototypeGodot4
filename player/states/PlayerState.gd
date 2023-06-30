extends State

class_name PlayerState

@onready var player: Player = get_tree().get_nodes_in_group("player")[0]

func set_horizontal_movement(speed, turn_speed,  cam_follow_speed, acceleration, delta):
	var move_dir = player.controls.get_movement_vector()
	var direction = Vector3(move_dir.x, 0, move_dir.y)
	
	player.move_rot = lerpf(player.move_rot, deg_to_rad(player.playercam._rot_h), cam_follow_speed * delta)
	direction = direction.rotated(Vector3.UP, player.move_rot)
	
	player.horizontal_velocity = lerp(player.horizontal_velocity, direction * speed, acceleration * delta)
	
	if move_dir != Vector2.ZERO:
		player.skin.rotation.y = lerp_angle(player.skin.rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)
