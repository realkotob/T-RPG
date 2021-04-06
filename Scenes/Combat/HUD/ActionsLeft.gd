extends HBoxContainer

onready var action_node_scene = preload("res://Scenes/Combat/HUD/ActorInfos/Actions/ActionLeft.tscn")

#### ACCESSORS ####


#### LOGIC ####

# Create or destroy the right number of action to corespond the amount of action
# the active actor has
func update_action_number(actor: TRPG_Actor):
	var max_action = actor.get_max_actions() + actor.get_action_modifier()
	
	var nb_icon = get_child_count()
	var diff = max_action - nb_icon
	
	# Create or destroy the right numbers of icons
	for _i in range(abs(diff)):
		if diff > 0:
			var action_node = action_node_scene.instance()
			call_deferred("add_child", action_node)
		if diff < 0:
			get_child(get_child_count() - 1).queue_free()


# Make the lights appear/disappear,
# based on the difference between the new value and actions_left
func update_display(actor: TRPG_Actor):
	update_action_number(actor)
	var new_value = actor.get_current_actions()
	
	var active_action = count_active_actions()
	var offset = new_value - active_action
	var actions_node_array = get_children()
	
	# If the new value is the actions_left, 
	# or if the actions_left would be negative after this method : abort
	if actions_node_array == [] or new_value == active_action or active_action + offset < 0 or offset == 0:
		return

	var unactive_actions = 0
	var total_actions = get_child_count()
	
	# If we are substracting from the current amount of actions,
	# Set the first action from which we will loop to be the first non-empty action
	if offset < 0:
		unactive_actions = total_actions - count_active_actions() - 1
	
	# Make the appropriate lights appear/disapear
	var activate : bool = offset > 0
	for i in range(abs(offset)):
		if i + unactive_actions >= actions_node_array.size():
			break
		actions_node_array[i + unactive_actions].set_active(activate)


# Return the number of action currently active
func count_active_actions() -> int:
	var nb = 0
	for child in get_children():
		if child.is_active():
			nb += 1
	return nb
