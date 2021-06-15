extends Node
class_name IA

var strategy : Node = null

#### ACCESSORS ####

func is_class(value: String): return value == "IA" or .is_class(value)
func get_class() -> String: return "IA"

func set_strategy(value: Node): strategy = value

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


func choose_best_strategy() -> void:
	var choose_strategy: Node = get_node("Passive")
	set_strategy(choose_strategy)


func make_decision(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	choose_best_strategy()
	# Check if the current strategy is the best one before making a decision
	return strategy.choose_best_action(actor, map)



#### INPUTS ####



#### SIGNAL RESPONSES ####
