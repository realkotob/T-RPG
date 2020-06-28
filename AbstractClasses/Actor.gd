extends IsoObject
class_name Actor

onready var states_node = $States
onready var move_node = $States/Move

var map_node : Node
var area_node : TileMap
var timeline_port_node : Node

export var portrait : Texture
export var timeline_port : Texture
export var MaxStats : Resource

var current_actions : int setget set_current_actions, get_current_actions
var current_movements : int setget set_current_movements, get_current_movements
var current_HP : int setget set_current_HP, get_current_HP
var current_MP : int setget set_current_MP, get_current_MP

#### BUILT-IN FUNCTIONS ####

# Add the node to the group allies
func _init():
	add_to_group("Allies")
	add_to_group("Actors")


# Set the current stats to the starting stats
func _ready():
	set_current_actions(get_max_actions())
	set_current_movements(get_max_movements())
	set_current_HP(get_max_HP())
	set_current_MP(get_max_MP())


### ACCESORS ###

func get_max_HP():
	return MaxStats.HP

func get_max_MP():
	return MaxStats.MP

func get_max_actions():
	return MaxStats.Actions

func get_max_movements():
	return MaxStats.Movements

func get_current_HP():
	return current_HP

func set_current_HP(value : int):
	current_HP = value

func get_current_MP():
	return current_MP

func set_current_MP(value : int):
	current_MP = value

func set_current_actions(value : int):
	current_actions = value

func get_current_actions():
	return current_actions

func get_current_movements():
	return current_movements

func set_current_movements(value : int):
	current_movements = value

func set_state(value : String):
	states_node.set_state(value)

func get_state() -> Object:
	return states_node.get_state()

func get_state_name() -> String:
	return states_node.get_state_name()

#### LOGIC ####

# Move the character along the given path
func move_along_path(path : PoolVector3Array):
	move_node.path = path
	set_state("Move")


func new_turn():
	current_actions = get_max_actions()


func get_height() -> int:
	return int(grid_position.z)
