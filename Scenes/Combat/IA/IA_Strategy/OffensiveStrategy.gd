extends IA_Strategy
class_name OffensiveStrategy

#### ACCESSORS ####

func is_class(value: String): return value == "OffensiveStrategy" or .is_class(value)
func get_class() -> String: return "OffensiveStrategy"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func move(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var max_turn_movement = actor.get_current_movements() * actor.get_current_actions()
	# Must be properly computed (Must takes wait situation & ailments in account)
	var next_turn_actions = actor.get_max_actions()
	var attack_range = actor.get_current_range()
	
	var next_turn_max_movement = (next_turn_actions - 1) * actor.get_current_movements()
	var total_movement = max_turn_movement + next_turn_max_movement
	
	var next_turn_targetable = map.get_targetables_in_range(actor, total_movement + attack_range)
	
	if next_turn_targetable.empty():
		return []
	
	var attack_effect = actor.get_current_attack_combat_effect_object()
	var target_to_chase = _choose_best_target(actor, next_turn_targetable, attack_effect, map)
	var target_cell = target_to_chase.get_current_cell()
	
	var path = map.find_approch_cell_path(actor, target_cell)
	if path.empty():
		return []
	
	var action = ActorActionRequest.new(actor, "move", [path])
	
	return [action]


#### INPUTS ####



#### SIGNAL RESPONSES ####
