extends PlayerState

func process(delta):
	object_check(Interactable)
	if player.controls.is_cancelling():
		state_machine.transition_to("OnGround")

func object_check(Interactable):
	if Interactable is NonInspectable:
		player.controls.is_cancelling()
		state_machine.transition_to("OnGround")
	else:
		return
