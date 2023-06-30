extends Node

class_name StateMachine

signal transitioned(state_path)

@export var initial_state := NodePath()

@onready var _state: State = get_node(initial_state)

func _init():
	add_to_group("state_machine")

func _ready():
	await owner.ready
	
	transition_to(initial_state)

func _input(event):
	_state.input(event)

func _unhandled_input(event):
	_state.unhandled_input(event)

func _process(delta):
	_state.process(delta)

func _physics_process(delta):
	_state.physics_process(delta)

func transition_to(state_path: NodePath):
	if !has_node(state_path):
		return
	
	var new_state := get_node(state_path)
	
	if new_state == _state || !(new_state is State):
		return
	
	_state.exit()
	_state = new_state
	new_state.enter()
	emit_signal("transitioned", state_path)
