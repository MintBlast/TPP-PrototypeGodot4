extends Interactor

@export var player: Player

var cached_closest: Interactable

func _ready() -> void:
	controller = player

func _physics_process(_delta: float) -> void:
	var new_closest: Interactable = get_closest_interactable()
	if new_closest != cached_closest:
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
			cancel(cached_closest)
		if new_closest:
			focus(new_closest)
		
		cached_closest = new_closest

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if cached_closest:
			interact(cached_closest)
	
	if event.is_action_pressed("uninteract"):
		if cached_closest:
			_on_area_exited(cached_closest)
		if !cached_closest:
			null
	
	# if exited but is still near interactable
	if event.is_action_pressed("uninteract") and cached_closest:
		# focus highlight even after exited
		focus(cached_closest)

func _on_area_exited(area: Interactable) -> void:
	if cached_closest == area:
		unfocus(area)
		cancel(area)
