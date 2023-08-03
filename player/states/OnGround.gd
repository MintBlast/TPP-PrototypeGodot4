extends PlayerState

func enter():
	pass
	#player.animation_tree.set()
	
func process(delta):
	if player.controls.is_jumping():
		state_machine.transition_to("InAir/Jumping")
	elif player.has_movement():
		state_machine.transition_to("OnGround/Walk")
	elif !player.has_movement():
		state_machine.transition_to("OnGround/Stopped")
	elif player.controls.is_interacting():
			state_machine.transition_to("OnGround/Interacting")
	elif player.controls.is_crouching():
		state_machine.transition_to("Crouching")
	
	
	
