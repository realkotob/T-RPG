extends Node2D

class_name Character

onready var states_node = $States
onready var move_node = $States/Move

var area_node : TileMap

export var portrait : Texture 
export var MaxStats : Resource

var current_actions : int setget set_current_actions, get_current_actions
var current_movements : int setget set_current_movements, get_current_movements
var current_HP : int setget set_current_HP, get_current_HP
var current_MP : int setget set_current_MP, get_current_MP

# Add the node to the group allies
func _init():
	add_to_group("Allies")


# Set the current stats to the starting stats
func _ready():
	set_current_actions(get_max_actions())
	set_current_movements(get_max_movements())
	set_current_HP(get_max_HP())
	set_current_MP(get_max_MP())


# Give the references to the children nodes and trigger their setup method
func setup():
	for child in get_children():
		if "character_node" in child:
			child.character_node = self
		
		if child.has_method("setup"):
			child.setup()


# Set the character in the given state
func set_state(value : String):
	states_node.set_state(value)


# Move the character along the given path
func move_along_path(path : PoolVector2Array):
	move_node.path = path
	set_state("Move")


func new_turn():
	current_actions = get_max_actions()

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
