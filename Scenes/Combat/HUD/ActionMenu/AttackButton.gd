extends CombatOptionButton

var map_node : Node setget set_map_node
var active_actor : Actor setget set_active_actor

#### ACCESSORS ####

func set_map_node(value: Node):
	map_node = value

func set_active_actor(value: Actor):
	active_actor = value

