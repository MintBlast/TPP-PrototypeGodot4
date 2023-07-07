extends PlayerState

func enter():
	pass

func process(delta):
	if !player.controls.is_crouching():
		state_machine.transition_to("OnGround")
	elif player.has_movement():
		state_machine.transition_to("Crouching/Moving")
	else:
		state_machine.transition_to("Crouching/Stopped")

func physics_process(delta):
	pass
