extends IA_Strategy
class_name ExploreStrategy

#### ACCESSORS ####

func is_class(value: String): return value == "ExploreStrategy" or .is_class(value)
func get_class() -> String: return "ExploreStrategy"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


# Function override
func move(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actor_movement = actor.get_current_movements()
	var actor_cell = actor.get_current_cell()
	var reachable_cell = map.pathfinding.find_reachable_cells(actor_cell, actor_movement + 1)
	
	var cell_by_dist_dict = IsoLogic.sort_cells_by_dist(actor_cell, reachable_cell)
	var farthest_cells = find_farthest_cell_array(cell_by_dist_dict)
	var rdm_cell = farthest_cells[randi() % farthest_cells.size()]
	
	var action = _approch_cell(map, actor, rdm_cell)
	return [action]


func find_farthest_cell_array(cell_by_dist_dict: Dictionary) -> Array:
	var biggest_key = -1
	
	for key in cell_by_dist_dict.keys():
		if key > biggest_key:
			biggest_key = key
	
	return cell_by_dist_dict[biggest_key]



#### INPUTS ####



#### SIGNAL RESPONSES ####
