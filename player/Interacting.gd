extends PlayerState

func process(delta):
	!player.has_movement()
	
	if player.controls.is_cancelling():
		#player.has_movement()
		state_machine.transition_to("OnGround")
