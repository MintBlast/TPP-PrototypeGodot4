extends CharacterBody3D

class_name Player

## CHANGE IT AND MOVE MECHANICS TO THEIR RESPECTIVE STATES

# character movement vectors
var DIRECTION = Vector3()
var GRAVITY_VEC = Vector3()
var MOVEMENT = Vector3()
var SNAP

@onready var state_machine : StateMachine = $StateMachine

#var state = IDLE

# character attributes such as speed
var SPEED
var walk_speed = 2.5
var run_speed = 5
#var JUMP_VELOCITY = 5
@onready var ACCEL = ground_accel
const ground_accel = 8
const air_accel = .75

# character's stuff e.g. skin and animations
@onready var skin = $Skin
@onready var controllable_camera = $ControllableCamera
@onready var playercam = $camera_mount/playercam
@onready var animation_player = $Skin/mixamo_base/AnimationPlayer

# character bools e.g. walk and run
var running = false
var moving

@export var turn_speed = 8

# variables for controls
@export var horizontal_mouse_sens = 0.5
@export var vertical_mouse_sens = 0.5
@export var controller_sensitivity = 0.6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# capture mouse - remove this once controls node is implemented
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	apply_controller_rotation()

func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	
	#if InputEventJoypadMotion and playercam.current:
	#	rotate_y(deg_to_rad(-axis_vector.x * controller_sensitivity))
	#	skin.rotate_y(deg_to_rad(axis_vector.x * controller_sensitivity))
	#	controllable_camera.rotate_x(deg_to_rad(-axis_vector.y * controller_sensitivity))
	#	controllable_camera.rotation.x = clamp(controllable_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _input(event):
	# if there is mouse movement and the player cam is set as current
	#if event is InputEventMouseMotion and playercam.current:
	#	rotate_y(deg_to_rad(-event.relative.x * horizontal_mouse_sens))
	#	skin.rotate_y(deg_to_rad(event.relative.x * horizontal_mouse_sens))
	#	camera_mount.rotate_x(deg_to_rad(-event.relative.y * vertical_mouse_sens))
		# limit camera's rotation position by clamping
	#	camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	pass

func _physics_process(delta):
	SPEED = walk_speed
	DIRECTION = Vector3.ZERO
	moving = false
	
	var H_ROTATION = global_transform.basis.get_euler().y
	var H_INPUT = Input.get_action_strength("right") - Input.get_action_strength("left")
	var F_INPUT = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	DIRECTION = Vector3(H_INPUT, 0, F_INPUT).rotated(Vector3.UP, H_ROTATION).normalized()
	
	if DIRECTION && state_machine.check_if_can_move():
		
		has_movement()
		
		if running:
			# INSERT A STATE
			#state = RUN
			if animation_player.current_animation != "running":
				animation_player.play("running")
		else:
			# INSERT A STATE
			#state = WALK
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
		# make the player rotate if player presses two multiple directions in the horizontal and forward inputs
		skin.rotation.y = lerp_angle(skin.rotation.y, atan2(H_INPUT, F_INPUT), turn_speed * delta)
	else:
		# INSERT A STATE
		#state = WALK
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		# INSERT A STATE
		SNAP = Vector3.DOWN
		ACCEL = air_accel
		velocity.y -= gravity * delta
	else:
		SNAP = -get_floor_normal()
		ACCEL = ground_accel
		#velocity.y -= JUMP_VELOCITY

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# INSERT A STATE
		#state = JUMP
		SNAP = Vector3.ZERO
		#velocity.y = JUMP_VELOCITY
		ACCEL = air_accel
	
	if Input.is_action_pressed("sprint"):
		SPEED = run_speed
		running = true
	else:
		SPEED = walk_speed
		running = false
	
	
	### PHYSICS ###
	velocity = velocity.lerp(DIRECTION * SPEED, ACCEL * delta)
	MOVEMENT = velocity + GRAVITY_VEC
	move_and_slide()

func has_movement():
	moving = true
