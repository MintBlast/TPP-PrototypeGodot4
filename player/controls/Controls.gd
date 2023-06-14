extends Node

class_name Controls

@export var min_pitch = -90
@export var max_pitch = 75
@export var zoom_step = 0.05
@export var horizontal_mouse_sens = 0.5
@export var vertical_mouse_sens = 0.5
@export var controller_sensitivity = 0.6

var _move_vec: Vector2 = Vector2.ZERO
var _cam_rot: Vector2 = Vector2.ZERO
var _zoom_scale: float = 0

# bool for states
var _is_capturing: bool = false
var _is_jumping: bool = false
var _is_sprinting: bool = false
var _is_interacting: bool = false
var _is_cancelling: bool = false

func _ready():
	# wait until the parent node e.g. player to set itself ready
	await get_parent().ready
	
	_is_capturing = true
	
	if _is_capturing:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if _is_capturing:
		
		#var H_ROTATION = global_transform.basis.get_euler().y
		var dx = Input.get_action_strength("right") - Input.get_action_strength("left")
		var dy = Input.get_action_strength("backward") - Input.get_action_strength("forward")
		
		_move_vec = Vector2(dx, -dy).normalized()
	
	_is_jumping = Input.is_action_just_pressed("jump")
	_is_sprinting = Input.is_action_pressed("sprint")
	_is_interacting = Input.is_action_pressed("interact")
	_is_cancelling = Input.is_action_pressed("uninteract")

func _input(event):
	
	if Input.is_action_just_pressed("ui_cancel"):
		_is_capturing = !_is_capturing
		
		if _is_capturing:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if _is_capturing && event is InputEventMouseMotion:
		_cam_rot.x -= event.relative.x * horizontal_mouse_sens
		_cam_rot.y -= event.relative.y * vertical_mouse_sens
		_cam_rot.y = clamp(_cam_rot.y, min_pitch, max_pitch)
	
	if _is_capturing:
		if Input.is_action_pressed("zoom_in"):
			_zoom_scale = clamp(_zoom_scale - zoom_step, 0, 1)
		if Input.is_action_pressed("zoom_out"):
			_zoom_scale = clamp(_zoom_scale + zoom_step, 0, 1)

func set_zoom_scale(zoom_scale):
	_zoom_scale = zoom_scale

func get_camera_rotation():
	return _cam_rot

func get_zoom_scale():
	return _zoom_scale
