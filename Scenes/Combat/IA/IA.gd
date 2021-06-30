extends Node
class_name IA

var strategy : Node = null
onready var strategy_container = $Strategies 
onready var criterias_container = $Criterias

#### ACCESSORS ####

func is_class(value: String): return value == "IA" or .is_class(value)
func get_class() -> String: return "IA"

func set_strategy(value: Node): strategy = value

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


func choose_best_strategy(actor: TRPG_Actor, map: CombatIsoMap) -> void:
	var total_incentives = Dictionary()

	# Fetch the incentives based on the IA criterias
	for criteria in criterias_container.get_children():
		var incentives = criteria.compute_strategy_incentives(actor, map)
		for key in incentives:
			if total_incentives.has(key):
				total_incentives[key] += incentives[key]
			else:
				total_incentives[key] = incentives[key]

	# Find the best strategy based on the incentives
	var best_strategy = ""
	var max_incentive = -INF

	for key in total_incentives.keys():
		var incentive = total_incentives[key]
		if incentive > max_incentive:
			max_incentive = incentive
			best_strategy = key

	var chose_strategy = strategy_container.get_node(best_strategy)
	set_strategy(chose_strategy)


func make_decision(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	choose_best_strategy(actor, map)
	print("%s decided to use the strategy %s" % [actor.name, strategy.name])
	return strategy.choose_best_action(actor, map)


#### INPUTS ####



#### SIGNAL RESPONSES ####
