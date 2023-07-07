extends RigidBody3D

class_name NonInspectable

@onready var omni_light_3d = $OmniLight3D
@onready var indicate = $Control/Label
@onready var trigger_sound = $TriggerSound
@onready var outline = $MeshInstance3D/Outline

var on = false

var already_detected = false

func light_up():
	on = !on
	
	if on == true:
		omni_light_3d.visible = true
	if on == false:
		omni_light_3d.visible = false

func detectsound():
	trigger_sound.play()

func focushighlight():
	outline.show()

func unfocushighlight():
	outline.hide()

func _on_interactable_focused(interactor):
	indicate.show()
	detectsound()
	focushighlight()

func _on_interactable_interacted(interactor):
	light_up()

func _on_interactable_unfocused(interactor):
	on = false
	indicate.hide()
	unfocushighlight()
