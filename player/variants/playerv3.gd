extends CharacterBody3D

class_name Player

signal movement_state_changed(new_state)

@export var max_slope_angle: float = 50

@onready var skin: Node3D = $Skin
@onready var playercam: ControllableCamera = $CamRoot/ControllableCamera
@onready var controls: Controls = $Controls
@onready var animation_tree: AnimationTree = $Skin/AnimationTree
@onready var state_machine: StateMachine = $StateMachine
@onready var water_surface_detector: Area3D = $WaterSurfaceDetector

var horizontal_velocity: Vector3 = Vector3.ZERO
var y_velocity: float = 0
var head_above_water: bool = true
var move_rot: float = 0

func _ready():
	state_machine.connect("transitioned", self._on_move_state_changed)

func _physics_process(delta):
	velocity = Vector3(horizontal_velocity.x, y_velocity, horizontal_velocity.z)
	move_and_slide()

func _on_WaterSurfaceDetector_area_entered(area):
	head_above_water = false

func _on_WaterSurfaceDetector_area_exited(area):
	head_above_water = true
	
func _on_move_state_changed(new_state):
	emit_signal("movement_state_changed", new_state)

func has_movement():
	return controls.get_movement_vector() != Vector2.ZERO || !velocity.is_equal_approx(Vector3.ZERO)



