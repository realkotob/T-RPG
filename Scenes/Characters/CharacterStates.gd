extends StatesMachine

#onready var state_label_node : Label = get_node("StateLabel")
onready var move_node : Node = get_node("Move")
onready var idle_node : Node = get_node("Idle")

var stats_node : Node
var character_node : Node

var map_node : TileMap
var area_node : TileMap
var cursor_node : Position2D


func setup():
	# Give the references it needs to children nodes
	idle_node.character_node = character_node
	idle_node.map_node = map_node
	idle_node.move_node = move_node
	idle_node.cursor_node = cursor_node
	idle_node.area_node = area_node
	idle_node.setup()
	
	move_node.character_node = character_node
	
	var _err = cursor_node.connect("cursor_change_position", idle_node, "on_cursor_change_position")
	
	set_state("Idle")


