extends Node
class_name StateMachine

var state = null
var previous_state = null

onready var parent = get_parent()

#this script should be attached to a node(the node node) which is a child of the object
#you want to give a state machine to

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

#function to be overwriten by the script which inherits this
func _state_logic(delta):
	pass

#another virtual func
func _get_transition(delta):
	return null

#and another one
func _enter_state(new_state, old_state):
	pass

#and another
func _exit_state(old_state, new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)
