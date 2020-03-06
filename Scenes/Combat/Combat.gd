extends Node

var actors : Array 
var allies : Array
var ennemies : Array

var active_actor := Node

func _ready():
	allies = get_tree().get_nodes_in_group("Allies")
	ennemies = get_tree().get_nodes_in_group("Ennemies")
	actors = allies + ennemies
	active_actor = actors[0]
