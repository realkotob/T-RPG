extends Node2D
class_name TeamsContainer

#### ACCESSORS ####

func is_class(value: String): return value == "TeamsContainer" or .is_class(value)
func get_class() -> String: return "TeamsContainer"


#### BUILT-IN ####

func _ready() -> void:
	var map = get_parent().get_parent()
	for team in get_children():
		team.map = map

#### VIRTUALS ####



#### LOGIC ####

func get_teams_in_team_side(team_side: int) -> Array:
	var teams_array = []
	
	for team in get_children():
		if team.get_team_side() == team_side:
			teams_array.append(team)
	
	return teams_array


func fetch_actors_in_team_side(team_side: int) -> Array:
	var actors_array := Array()
	for child in get_children():
		if child.is_team_side(team_side):
			for actor in child.get_actors():
				actors_array.append(actor)
	return actors_array


func fetch_all_actors() -> Array:
	var actors_array := Array()
	for child in get_children():
		for actor in child.get_actors():
			actors_array.append(actor)
	return actors_array


#### INPUTS ####



#### SIGNAL RESPONSES ####
