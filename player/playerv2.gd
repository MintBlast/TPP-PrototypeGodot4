extends CharacterBody3D

class_name Player

# THIS IS THE IDEAL PLAYER CONTROLLER - USE THIS AS TEMPLATE AND DON'T ADD ANYTHING ELSE TO IT!!
# MODIFY V3 AND OTHER VARIANTS PRECEDED BY IT INSTEAD!
# ANY MODIFICATIONS WILL BE ADDED AS A COMMENT BELOW THIS LINE!

var DIRECTION = Vector3()
var GRAVITY_VEC = Vector3()
var MOVEMENT = Vector3()
 
var SPEED 
var walk_speed = 2.5
var run_speed = 5
var GRAVITY = 9.5
var MOUSE_SENSE = 0.20
var SNAP
 
const JUMP_VELOCITY = 5
const ACCEL_DEFAULT = 8
const ACCEL_AIR = 1
 
var running = false

@export var turn_speed = 10

@onready var camera_mount = $camera_mount
@onready var camera_3d = $camera_mount/playercam
@onready var skin = $Skin
@onready var animation_player = $Skin/mixamo_base/AnimationPlayer
@onready var ACCEL = ACCEL_DEFAULT
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
 
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSE))
		skin.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSE))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSE))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-80), deg_to_rad(80))
 
func _physics_process(delta):
	
	SPEED = walk_speed
	DIRECTION = Vector3.ZERO
	var H_ROTATION = global_transform.basis.get_euler().y
	var F_INPUT = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var H_INPUT = Input.get_action_strength("right") - Input.get_action_strength("left")
	DIRECTION = Vector3(H_INPUT, 0, F_INPUT).rotated(Vector3.UP, H_ROTATION).normalized()
	
	if DIRECTION:
		if running:
			if animation_player.current_animation != "running":
				animation_player.play("running")
		else:
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
		skin.rotation.y = lerp_angle(skin.rotation.y, atan2(H_INPUT, F_INPUT), turn_speed * delta)
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
	
	if not is_on_floor():
		SNAP = Vector3.DOWN
		ACCEL = ACCEL_AIR
		velocity.y -= GRAVITY * delta
	else:
		SNAP = -get_floor_normal()
		ACCEL = ACCEL_DEFAULT
		velocity.y -= JUMP_VELOCITY 
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		SNAP = Vector3.ZERO
		ACCEL = ACCEL_AIR
		velocity.y = JUMP_VELOCITY 
	
	if Input.is_action_pressed("sprint"):
		SPEED = run_speed
		running = true
	else:
		SPEED = walk_speed
		running = false
	
	# velocity is interpolated with direction * speed along with the acceleration with changing time
	velocity = velocity.lerp(DIRECTION * SPEED, ACCEL * delta)
	MOVEMENT = velocity + GRAVITY_VEC
	move_and_slide()
