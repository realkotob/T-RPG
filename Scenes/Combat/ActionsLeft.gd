extends HBoxContainer

onready var actions_node_array = get_children()

var max_action : int = 3
var actions_left : int = 3

# Make the default display correspond to the default actions_left value 
func setup():
	update_display(actions_left)


# Make the lights appear/disappear,
# based on the difference between the new value and actions_left
func update_display(new_value : int):
	var offset = new_value - actions_left
	
	# If the new value is the actions_left, 
	# or if the actions_left would be negative after this method : abort
	if new_value == actions_left or actions_left + offset < 0:
		return
	
	var empty_actions = 0
	
	# If we are substracting from the current amount of actions,
	# Set the first action from which we will loop to be the first non-empty action
	if offset < 0:
		empty_actions = max_action - actions_left
		if empty_actions < 0:
			empty_actions = 0
	
	# Make the appropriate lights appear/disapear
	for i in range(abs(offset)):
		actions_node_array[i + empty_actions].get_node("Light").set_visible(offset > 0)
	
	# Set the new action_left value
	actions_left = new_value
