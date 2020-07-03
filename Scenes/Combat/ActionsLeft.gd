extends HBoxContainer

onready var action_node_scene = preload("res://Scenes/Combat/HUD/ActorInfos/Actions/ActionLeft.tscn")

var active_actor : Actor setget set_active_actor, get_active_actor

var max_action : int = 0
var actions_left : int = 0

#### ACCESSORS ####

func set_active_actor(value: Actor):
	active_actor = value

func get_active_actor() -> Actor:
	return active_actor


func new_turn():
	max_action = active_actor.get_max_actions()
	actions_left = active_actor.get_current_actions()
	
	var nb_icon = get_child_count()
	var diff : int = 0
	
	if max_action > actions_left:
		diff = max_action - nb_icon
	else:
		diff = actions_left - nb_icon
	
	# Create or destroy the right numbers of icons
	for _i in range(abs(diff)):
		if diff > 0:
			var action_node = action_node_scene.instance()
			call_deferred("add_child", action_node)
		if diff < 0:
			get_child(get_child_count() - 1).queue_free()
	
	call_deferred("activate_action_icons")


func activate_action_icons():
	var icons_array = get_children()
	
	for i in range(actions_left):
		icons_array[i].set_active(true)


# Make the lights appear/disappear,
# based on the difference between the new value and actions_left
func update_display(new_value: int):
	var offset = new_value - actions_left
	var actions_node_array = get_children()
	
	# If the new value is the actions_left, 
	# or if the actions_left would be negative after this method : abort
	if new_value == actions_left or actions_left + offset < 0:
		return

	var empty_actions = 0

	# If we are substracting from the current amount of actions,
	# Set the first action from which we will loop to be the first non-empty action
	if offset < 0:
		empty_actions = get_child_count() - count_active_actions()

	# Make the appropriate lights appear/disapear
	for i in range(abs(offset)):
		actions_node_array[i + empty_actions].set_active(offset > 0)

	# Set the new action_left value
	actions_left = new_value


func count_active_actions() -> int:
	var nb = 0
	for child in get_children():
		if child.is_active():
			nb += 1
	return nb
