extends Node

class_name State

@onready var state_machine
@onready var parent = get_parent()

func _init():
	# make sure the node is in the "state" group
	add_to_group("state")

func _ready():
	state_machine = _get_state_machine(self)

# Executed when entering the state
func enter():
	if parent.is_in_group("state"):
		parent.enter()

func exit():
	if parent.is_in_group("state"):
		parent.exit()

func input(event):
	if parent.is_in_group("state"):
		parent.input(event)

func unhandled_input(event):
	if parent.is_in_group("state"):
		parent.unhandled_input(event)

func process(delta):
	if parent.is_in_group("state"):
		parent.process(delta)

func physics_process(delta):
	if parent.is_in_group("state"):
		parent.physics_process(delta)

func _get_state_machine(node):
	if !node:
		return null
	
	if node.is_in_group("state_machine"):
		return node
	
	return _get_state_machine(node.get_parent())
