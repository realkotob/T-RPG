extends Node2D
class_name ActorTeam

enum TEAM_TYPE{
	ALLY,
	NPC_ALLY,
	ENEMY
}

#### ACCESSORS ####

func is_class(value: String): return value == "ActorTeam" or .is_class(value)
func get_class() -> String: return "ActorTeam"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func is_cell_in_view_field(cell: Vector3):
	for array in get_view_field():
		if cell in array:
			return true
	return false 


# Check if the view field of the team is empty
func is_view_field_empty() -> bool:
	for actor in get_children():
		var actor_view_field = actor.get_view_field()
		if actor_view_field.empty() or actor_view_field[0].empty():
			return true
	return false


# Returns the team view field, by adding every ally's view field
# Assure a tile can't be barely visible, if it is visible by another actor
func get_view_field() -> Array:
	var view_field = [[], []]
	
	for i in range(2):
		for actor in get_children():
			for cell in actor.get_view_field()[i]:
				if not cell in view_field[i]:
					if i != 0 && cell in view_field[IsoObject.VISIBILITY.VISIBLE]:
						continue
					view_field[i].append(cell)
	
	return view_field


#### INPUTS ####



#### SIGNAL RESPONSES ####
