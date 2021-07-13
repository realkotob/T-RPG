extends IA_Strategy
class_name RunAwayStrategy

#### ACCESSORS ####

func is_class(value: String): return value == "RunAwayStrategy" or .is_class(value)
func get_class() -> String: return "RunAwayStrategy"


#### BUILT-IN ####



#### VIRTUALS ####

func move(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var actions_array = []
	var safe_dir_array = _get_run_away_dir(actor, map)
	var chosen_dir = safe_dir_array[randi() % safe_dir_array.size()]
	var total_movement = actor.get_current_actions() * actor.get_current_movements()
	
	var dest = _find_destination(actor, map, chosen_dir)
	var path = find_approch_cell_path(map, actor, dest, total_movement)
	
	var splitted_path_array = _split_move_path(path, actor.get_current_movements())
	
	for i in range(actor.get_current_actions()):
		actions_array.append(ActorActionRequest.new(actor, "move", [splitted_path_array[i]]))
	
	return actions_array



#### LOGIC ####


func _get_run_away_dir(actor: TRPG_Actor, map: CombatIsoMap) -> PoolVector2Array:
	var visible_opponents = map.get_nearby_opponents(actor, actor.get_view_range(), true)
	var free_dir_array = Array()
	
	for i in range(-1, 2, 1):
		for j in range(-1, 2, 1):
			free_dir_array.append(Vector2(j, i))
	
	for opponent in visible_opponents:
		var dir = IsoLogic.iso_dirV(actor.get_current_cell(), opponent.get_current_cell())
		if dir in free_dir_array:
			free_dir_array.erase(dir)
	
	return PoolVector2Array(free_dir_array)


func _find_destination(actor: TRPG_Actor, map: CombatIsoMap, dir: Vector2) -> Vector3:
	var normalized_dir = dir if dir.x == 0 or dir.y == 0 else dir / 2
	var movement_pts = actor.get_current_movements() * actor.get_current_actions()
	var move_vector = normalized_dir * movement_pts
	
	var theorical_dest = actor.get_current_cell() + Vector3(move_vector.x, move_vector.y, 0)
	
	return map.get_nearest_reachable_cell(theorical_dest, actor)



#### INPUTS ####



#### SIGNAL RESPONSES ####
