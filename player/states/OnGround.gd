extends PlayerState

func enter():
	pass
	#player.animation_tree.set()
	
func process(delta):
	if player.controls.is_jumping() and player.is_on_floor():
		state_machine.transition_to("InAir/Jumping")
	elif player.controls.is_crouching():
		state_machine.transition_to("Crouching")
	elif player.has_movement():
		state_machine.transition_to("OnGround/Walk")
	elif !player.has_movement():
		state_machine.transition_to("OnGround/Stopped")
		if !player.has_movement() and player.controls.is_interacting():
				state_machine.transition_to("OnGround/Stopped/Interacting")
	
	