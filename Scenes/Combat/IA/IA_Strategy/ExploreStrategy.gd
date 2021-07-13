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
	var smallest_knowledge_id = find_segment_to_explore(actor, map)
	var less_known_seg_center = map.segment_get_center(smallest_knowledge_id)
	
	var path = map.find_approch_cell_path(actor, less_known_seg_center, -1)
	var splitted_path = _split_move_path(path, actor.get_current_movements())
	var actions_array = []
	var nb_actions = actor.get_current_actions()
	
	for i in range(nb_actions):
		var action = null
		if i < splitted_path.size():
			action = ActorActionRequest.new(actor, "move", [splitted_path[i]])
		else:
			action = ActorActionRequest.new(actor, "wait")
		
		actions_array.append(action)
	
	return actions_array


func find_farthest_cell_array(cell_by_dist_dict: Dictionary) -> Array:
	var biggest_key = -1
	
	for key in cell_by_dist_dict.keys():
		if key > biggest_key:
			biggest_key = key
	
	return cell_by_dist_dict[biggest_key]


func find_segment_to_explore(actor: TRPG_Actor, map: CombatIsoMap) -> int:
	var current_segment_id = map.cell_get_segment(actor.get_current_cell())
	var current_segment_pos = map.segment_get_pos(current_segment_id)
	var adjacent_segments_array = IsoLogic.get_adjacent_cells(current_segment_pos)
	
	var team = actor.get_team()
	
	var smallest_knowledge = INF
	var smallest_knowledge_id = -1
	
	for i in range(adjacent_segments_array.size()):
		var seg = adjacent_segments_array[i]
		
		if !map.segment_exists_v(seg):
			continue
		
		var seg_id = map.get_segment_id(seg)
		var knowledge = team.get_segment_knowledge(seg_id)
		
		if knowledge < smallest_knowledge:
			smallest_knowledge = knowledge
			smallest_knowledge_id = seg_id
	
	return smallest_knowledge_id


#### INPUTS ####



#### SIGNAL RESPONSES ####
