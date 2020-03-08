extends Position2D

class_name Character

var get 

var map_node : TileMap
var map_area_node : TileMap 
var cursor_node : Node

export var starting_stats : Resource

var MaxStats : Resource
var ActualStats : Resource


# Add the node to the group allies
func _init():
	add_to_group("Allies")


func setup():
	# Set the current stats to the starting stats
	MaxStats = starting_stats
	ActualStats = MaxStats
	
	for child in get_children():
		if "cursor_node" in child:
			child.cursor_node = cursor_node
		
		if "character_node" in child:
			child.character_node = self
		
		if "map_node" in child:
			child.map_node = map_node
		
		if "area_node" in child:
			child.area_node = map_area_node
		
		if child.has_method("setup"):
			child.setup()


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
