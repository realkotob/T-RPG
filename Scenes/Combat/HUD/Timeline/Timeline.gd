extends Node2D
class_name Timeline

onready var TL_portrait_scene = preload("res://Scenes/Combat/HUD/Timeline/TL_Portrait/TL_Portrait.tscn")
onready var order_node = $Order

func set_state(state_name: String):
	$TimeLineStates.set_state(state_name)


# Create the timeline out of the array of actors
func generate_timeline(actors_array : Array):
	for i in range(actors_array.size()):
		var actor = actors_array[i]
		var new_TL_port = TL_portrait_scene.instance()
		
		order_node.add_child(new_TL_port)
		
		var slot = new_TL_port.get_node("Border").get_texture().get_height() + 2
		new_TL_port.actor_node = actor
		new_TL_port.set_portrait_texture(actor.timeline_port)
		new_TL_port.set_position(Vector2(0, slot * i))
		
		if actor.is_team_side(ActorTeam.TEAM_TYPE.ALLY):
			new_TL_port.get_node("Background").set_modulate(Color.red)



# Move the timeline so it matches the future_actors_order
func move_timeline(actors_order: Array, future_actors_order: Array):
	
	# Check if the two array size corresponds, print a error message and return if not
	if len(actors_order) != len(future_actors_order):
		print("ERROR: move_timeline() - The actors_array array size doesn't correspond the future_actors_order")
		return
	
	var actors_to_move_down : Array = []
	var actors_to_move_up : Array = []
	
	sort_actors_by_destination(actors_order, future_actors_order, actors_to_move_down, actors_to_move_up)
	
	# Give every portrait its new destination
	for actor in actors_order:
		var timeline_portrait = get_actor_portrait(actor)
		timeline_portrait.timeline_id_dest = future_actors_order.find(actor)
	
	# Give every state the array of portraits
	var portrait_array = get_portraits()
	var states_array = $TimeLineStates.get_children()
	
	for state in states_array:
		if "portrait_array" in state:
			state.portrait_array = portrait_array
	
	# Triggers the movement of the timeline
	set_state("Extract")


# Sort every actor by destination
# Store every actor going up in the actors_to_move_up array 
# and every actors that move up in the actors_to_move_up array
func sort_actors_by_destination(actors_order: Array, future_actors_order: Array, actors_to_move_down: Array, actors_to_move_up: Array):
	for i in range(len(actors_order)):
		var new_id = future_actors_order.find(actors_order[i])
		if new_id > i:
			actors_to_move_down.append(actors_order[i])
		elif new_id < i:
			actors_to_move_up.append(actors_order[i])


# Count the number of actors before the given index 
func count_moving_actors_before_index(actors_array: Array, actors_to_move: Array, index: int):
	var count := 0
	for i in range(index):
		if actors_array[i] in actors_to_move:
			count += 1
	
	return count 


# Update the timeline order
# Queue free the actors portrait that are no longer in combat
# Move the portraits order in the hierarchy, so it correspond to the actors order
func update_timeline_order(actor_order : Array):
	for child in order_node.get_children():
		if !(child.actor_node in actor_order):
			child.queue_free()
		else:
			order_node.move_child(child, actor_order.find(child.actor_node))


# Get the portrait corresponding to the given actor
func get_actor_portrait(actor: TRPG_Actor) -> TimelinePortrait:
	for child in order_node.get_children():
		if child is TimelinePortrait && child.actor_node == actor:
			return child
	return null


func remove_actor_portrait(actor: TRPG_Actor):
	var portrait = get_actor_portrait(actor)
	portrait.queue_free()


func get_portraits() -> Array:
	return order_node.get_children()


#### SIGNALS RESPONSES ####

func on_timeline_movement_finished():
	EVENTS.emit_signal("timeline_movement_finished")
