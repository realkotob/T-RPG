extends Position2D

class_name Character

onready var states_node = get_node("States")
onready var stats_node = get_node("Attributes/Stats")

var map_node : TileMap
var map_area_node : TileMap 
var cursor_node : Node


# Add the node to the group allies
func _init():
	add_to_group("Allies")


func setup():
	# Give the nodes references they need to the children
	states_node.stats_node = stats_node
	states_node.character_node = self
	states_node.map_node = map_node
	states_node.area_node = map_area_node
	states_node.cursor_node = cursor_node
	
	# Initialize the states node
	states_node.setup()