extends StatesMachine

#onready var state_label_node : Label = get_node("StateLabel")
onready var move_node : Node = get_node("Move")
onready var idle_node : Node = get_node("Idle")

var stats_node : Node
var character_node : Node

var map_node : TileMap
var area_node : TileMap
var cursor_node : Position2D


# Connect signal emited, or received to a child node
func connect_signals():
	var _err
	_err = idle_node.connect("path_chosen", move_node, "_on_Idle_path_chosen")
	_err = idle_node.connect("path_valid", cursor_node, "_on_path_valid")
	_err = idle_node.connect("draw_movement_area", area_node, "_on_draw_movement_area")
	_err = cursor_node.connect("cursor_change_position", idle_node, "on_cursor_change_position")


func setup():
	# Give the references it needs to children nodes
	idle_node.stats_node = stats_node
	idle_node.character_node = character_node
	idle_node.map_node = map_node
	idle_node.setup()
	
	move_node.character_node = character_node
	
	connect_signals()
	
	set_state("Idle")
