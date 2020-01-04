extends Node

class_name Attributes

onready var stats_node = get_node("Stats")

export var starting_stats : Resource

func _ready():
	stats_node.initialize(starting_stats)