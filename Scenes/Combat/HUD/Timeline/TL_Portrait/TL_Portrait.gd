extends Position2D
class_name TimelinePortrait

onready var portrait_node = $Portrait
var actor_node : Node

var timeline_id_dest := -1


func set_portrait_texture(portrait: Texture):
	portrait_node.set_texture(portrait)


func get_slot_height() -> float:
	return get_node("Border").get_texture().get_height() + 2
