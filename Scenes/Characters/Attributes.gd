extends Node

class_name Attributes

onready var Stats = $Stats

export var starting_stats : Resource

func _ready():
	Stats.initialize(starting_stats)