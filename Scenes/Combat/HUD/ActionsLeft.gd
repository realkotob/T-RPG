extends HBoxContainer

onready var action_node_scene = preload("res://Scenes/Combat/HUD/ActorInfos/Actions/ActionLeft.tscn")

var actor_max_actions : int = 0

#### ACCESSORS ####


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("active_actor_turn_started", self, "_on_active_actor_turn_started")


#### LOGIC ####

# Create or destroy the right number of action to corespond the amount of action
# the active actor has
func update_max_action_number() -> void:
	var nb_icon = get_child_count()
	var diff = actor_max_actions - nb_icon
	
	# Create or destroy the right numbers of icons
	for _i in range(abs(diff)):
		if diff > 0:
			var action_node = action_node_scene.instance()
			call_deferred("add_child", action_node)
		if diff < 0:
			get_child(get_child_count() - 1).queue_free()


func update_display(actor: TRPG_Actor) -> void:
	if get_child_count() == 0:
		return
	
	var nb_current_active_actions = count_active_actions()
	var actions_left = actor.get_current_actions()
	
	var diff = nb_current_active_actions - actions_left
	
	if diff == 0:
		return
	elif diff > 0:
		for _i in range(diff):
			var id = _find_first_active_action_id()
			get_child(id).set_active(false)
	else:
		for _i in range(abs(diff)):
			var id = Math.clampi(_find_first_active_action_id() + 1, 0, get_child_count() - 1)
			var action_node = get_child(id)
			if is_instance_valid(action_node):
				action_node.set_active(true)


# Return the number of action currently active
func count_active_actions() -> int:
	var nb = 0
	for child in get_children():
		if child.is_active():
			nb += 1
	return nb


func _find_first_active_action_id() -> int:
	for child in get_children():
		if child.is_active():
			return child.get_index()
	return -1


#### SIGNAL RESPONSES ####

func _on_active_actor_turn_started(actor: TRPG_Actor) -> void:
	var current_actions = actor.get_current_actions()
	var max_action = actor.get_max_actions()
	
	actor_max_actions = int(max(current_actions, max_action))
	
	update_max_action_number()
	update_display(actor)
