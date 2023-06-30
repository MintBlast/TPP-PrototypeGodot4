extends CharacterBody3D

# USE ME FOR LATER USE - DEBUGGING PURPOSES

@onready var camera_mount = $camera_mount
@onready var animation_player = $Skin/mixamo_base/AnimationPlayer
@onready var skin = $Skin
@onready var label = $Control/Label

const JUMP_VELOCITY = 4.5
var DIRECTION = Vector3()
var GRAVITY_VEC = Vector3()
var MOVEMENT = Vector3()
var SNAP

var SPEED
var walk_speed = 2.5
var run_speed = 5.0

var accel
var ground_accel = 0.5
var air_accel = 0.25

var running = false
var jumping = false
var is_locked = false

@export var turn_speed = 10

@export var horizontal_sensitivity = 0.5
@export var vertical_sensitivity = 0.5
@export var controller_hor_sensitivity = 0.5
@export var controller_ver_sensitivity = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# capture mouse pointer
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	
	if InputEventJoypadMotion:
		rotate_y(deg_to_rad(axis_vector.x) * controller_hor_sensitivity)
		skin.rotate_y(deg_to_rad(axis_vector.x) * controller_hor_sensitivity)
		camera_mount.rotate_x(deg_to_rad(axis_vector.y) * controller_ver_sensitivity)

func _input(event):
	# camera movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * horizontal_sensitivity))
		skin.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * vertical_sensitivity))
	
	apply_controller_rotation()

func _physics_process(delta):
	# locks camera to max top and bottom position
	camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(75))
	
	# run
	if Input.is_action_pressed("run"):
		SPEED = run_speed
		running = true
	else:
		SPEED = walk_speed
		running = false

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var DIRECTION = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if DIRECTION:
		if running:
			if animation_player.current_animation != "running":
				animation_player.play("running")
		else:
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
		
		# makes the animation rotate at the direction and position (-direction works, direction is inverted for some reason)
		if !is_locked:
			#skin.look_at(position + -direction) <- rotation feels direct and rough and not smooth
			# this is way smoother by using interpolation
			skin.rotation.y = lerp_angle(skin.rotation.y, atan2(input_dir.x, input_dir.y), turn_speed * delta)
		velocity.x = DIRECTION.x * SPEED 
		velocity.z = DIRECTION.z * SPEED
		
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		#velocity = velocity.lerp(DIRECTION * SPEED, accel * delta)
	
	if !is_locked:
		move_and_slide()
