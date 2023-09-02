extends RigidBody3D

# this game object's script is inherited from the interactable class - no need to classify this game object since its considered an interactable

@onready var outline = $MeshInstance3D/Outline
@onready var trigger_sound = $TriggerSound
@onready var indicate = $Control/Label
@export var inspectcam : Camera3D
@export var playercam : Camera3D
@export var player : Player

var rotating = false
var next_mouse_position
var prev_mouse_position

func focushighlight():
	outline.show()

func unfocushighlight():
	outline.hide()

func detectsound():
	trigger_sound.play()

func _process(delta):
	pass
	#if Input.is_action_just_pressed("rotate"):
	#	rotating = true
	#	prev_mouse_position = get_viewport().get_mouse_position()
	#if Input.is_action_just_released("rotate"):
	#	rotating = false
	
	#if (rotating):
	#	next_mouse_position = get_viewport().get_mouse_position()
	#	rotate_y((next_mouse_position.x - prev_mouse_position.x) * .25 * delta)
	#	rotate_x((next_mouse_position.y - prev_mouse_position.y) * .25 * delta)
	#	prev_mouse_position = next_mouse_position

func inspect():
	#pass
	playercam.current = true
	
	if playercam.current == true:
		playercam.clear_current(true)
		inspectcam.current == true

func _on_interactable_focused(interactor):
	focushighlight()
	detectsound()
	indicate.show()

func _on_interactable_interacted(interactor):
	inspect()
	indicate.text = "Leave? [V]"
	!player.has_movement()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_interactable_unfocused(interactor):
	unfocushighlight()

func _on_interactable_cancel(interactor):
	indicate.hide()
	
	indicate.text = "Interact? [E]"
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#player.has_movement()
	
	if inspectcam.current == true:
		inspectcam.clear_current(true)
		playercam.current == true
