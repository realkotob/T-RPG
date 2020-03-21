extends Node2D

onready var TL_portrait_scene = preload("res://Scenes/Combat/HUD/Timeline/TL_Portrait/TL_Portrait.tscn")

# Create the timeline out of the array of actors
func generate_timeline(actors_array : Array):
	var i = 0
	
	for actor in actors_array:
		var new_TL_port = TL_portrait_scene.instance()
		
		actor.timeline_port_node = new_TL_port
		add_child(new_TL_port)
		
		var slot = new_TL_port.get_node("Border").get_texture().get_height() + 2
		new_TL_port.actor_node = actor
		new_TL_port.set_portrait_texture(actor.timeline_port)
		new_TL_port.set_position(Vector2(0, slot * i))
		
		i += 1


# Update the timeline order
# Queue free the actors portrait that are no longer in combat
# Move the portraits order in the hierarchy, so it correspond to the actors order
func update_timeline_order(actor_order : Array):
	for child in get_children():
		if !(child.actor_node in actor_order):
			child.queue_free()
		else:
			move_child(child, actor_order.find(child.actor_node))
