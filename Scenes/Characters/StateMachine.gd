extends Position2D

class_name StatesMachine

onready var StateLabel := $StateLabel 

# Define the list of possible states, and give the path to the corresponding node
onready var states_map = {
	"idle" : $States/Idle,
	"move" : $States/Move
}

onready var current_state : Object
onready var previous_state : Object

var state_name

signal state_changed

func _ready():
	var _err = self.connect("state_changed", StateLabel, "on_Character_state_changed")
	state_name = "idle"
	_set_state(states_map[state_name])

# Call for the current state process
func _physics_process(delta):
	state_name = current_state.update(self, delta)
	if state_name:
		_set_state(states_map[state_name])

# Set a new state
func _set_state(new_state):
	
	# Discard the method if the new_state is the current_state
	if new_state == current_state:
		return
	
	# Use the exit state function of the current state
	if current_state != null:
		current_state.exit_state(self)
	
	# Change the current state, and the previous state
	previous_state = current_state
	current_state = new_state
	
	# Use the enter_state function of the current state
	if new_state != null:
		current_state.enter_state(self)
	
	emit_signal("state_changed", state_name)