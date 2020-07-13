extends CombatStateBase

#### COMBAT ATTACK STATE ####

func enter_state():
	generate_reachable_aera()


func generate_reachable_aera():
	var actor_cell = active_actor.get_current_cell()
	var adjacents = map_node.get_adjacent_cells(actor_cell)
	map_node.area_node.draw_area(adjacents, 1)

