extends Node3D

class_name InspectCamera

@export var rotate_speed: float = 10
@export var zoom_speed: float = 10
@export var min_distance: float = 1
@export var max_distance: float = 8

@onready var camera_mount = $CameraMount
@onready var inspectcam = $CameraMount/inspectcam
@onready var controls: Controls = get_tree().get_nodes_in_group("controls")[0]

var _rot_h: float = 0
var _rot_v: float = 0
var distance: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_parent().ready
	
	#distance = inspectcam.transform.origin.z
	
	call_deferred("_initialize_zoom_scale")

func _initialize_zoom_scale():
	var initial_zoom_scale := (distance - min_distance) / (max_distance - min_distance)
	controls.set_zoom_scale(initial_zoom_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#var cam_rot: Vector2 = controls.get_camera_rotation()
	#_rot_h = cam_rot.x
	#_rot_v = cam_rot.y
	
	#distance = controls.get_zoom_scale() * (max_distance - min_distance) + min_distance

#func _physics_process(delta):
	#camera_mount.rotation.y = lerpf(camera_mount.rotation.y, deg_to_rad(_rot_h), rotate_speed * delta)
	#camera_mount.rotation.x = lerpf(camera_mount.rotation.x, deg_to_rad(_rot_v), rotate_speed * delta)
	
	#inspectcam.transform.origin.z = lerpf(inspectcam.transform.origin.z, distance, zoom_speed * delta)
