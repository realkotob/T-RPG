extends Node2D

class_name Character

onready var states_node = $States
onready var move_node = $States/Move

var area_node : TileMap

export var portrait : Texture 
export var starting_stats : Resource

var MaxStats : Resource
var ActualStats : Resource


# Add the node to the group allies
func _init():
	add_to_group("Allies")


# Set the current stats to the starting stats
func _ready():
	MaxStats = starting_stats
	ActualStats = starting_stats


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


### ACCESORS ###

func get_max_HP():
	return MaxStats.HP


func get_max_MP():
	return MaxStats.MP


func get_max_actions():
	return MaxStats.Actions


func get_max_movements():
	return MaxStats.Movements


func get_acutal_HP():
	return ActualStats.HP


func get_actual_MP():
	return ActualStats.MP


func get_actual_actions():
	return ActualStats.Actions


func get_actual_movements():
	return ActualStats.Movements
