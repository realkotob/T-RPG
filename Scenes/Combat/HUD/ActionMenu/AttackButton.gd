extends CombatOptionButton

var map_node : Node setget set_map_node
var active_actor : Actor setget set_active_actor

#### ACCESSORS ####

func set_map_node(value: Node):
	map_node = value

func set_active_actor(value: Actor):
	active_actor = value

#### LOGIC ####

func update_active():
	var actor_cell = active_actor.get_current_cell()
	var actor_range = active_actor.get_current_attack_range()
	var reachables = map_node.get_cells_in_range(actor_cell, actor_range)
	set_disabled(!is_target_in_reachable(reachables))


func is_target_in_reachable(cells_array: PoolVector3Array) -> bool:
	for cell in cells_array:
		var obj = map_node.get_object_on_cell(cell)
		if obj is Actor or obj is Obstacle:
			if obj != active_actor:
				return true
	return false
