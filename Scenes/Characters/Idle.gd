extends States

onready var character_node := find_parent("Character")
onready var map_node := get_tree().get_root().get_node("Master/Map")
onready var area_node := get_tree().get_root().get_node("Master/Map/Area")
onready var move_node := get_parent().get_node("Move")
onready var stats_node := get_parent().get_parent().get_node("Attributes/Stats")
onready var cursor_sprite_node := get_tree().get_root().get_node("Master/Cursor/Sprite")

var path := PoolVector2Array()
var potential_path := PoolVector2Array()
var position : Vector2

signal path_chosen
signal path_valid
signal draw_movement_area

func _ready():
	var _err = self.connect("path_chosen", move_node, "_on_Idle_path_chosen")
	_err = self.connect("path_valid", cursor_sprite_node, "_on_path_valid")
	_err = self.connect("draw_movement_area", area_node, "_on_draw_movement_area")

func update(_host, _delta):
	var is_path_valid = check_path(path)
	if is_path_valid == true:
		emit_signal("path_chosen", path)
		return "Move"

# When the state is entered define the actor postiton, empty the path and potential_path array, and set a potential_path
func enter_state(host):
	
	position = character_node.position
	initialize_path_value()
	set_potential_path(host.get_viewport().get_mouse_position())
	emit_signal("draw_movement_area", position, stats_node.get_actual_movements())

# When the state is exited, empty the path and potential path array
func exit_state(_host):
	initialize_path_value()

# On click, give the active character its destination
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		path = potential_path

# Ask Astar for a path between current actor's position and cursor position
func set_potential_path(cursor_pos) -> void:
	potential_path = map_node.find_path(position, cursor_pos)
	var is_path_valid = check_path(potential_path)
	emit_signal("path_valid", is_path_valid)

# Empty the path and potential path arrays
func initialize_path_value():
	path = []
	potential_path = []

# Check if the path is valid, return true or false
func check_path(path : PoolVector2Array) -> bool:
	var movements = stats_node.get_actual_movements()
	if len(path) > 0 and len(path) - 1 <= movements:
		return true
	else:
		return false
