extends Object
class_name IA_Strategy

export var action_list := PoolStringArray() 

export var default_coef : Dictionary = {
	"wait" : 20.0,
	"attack" : 0.0,
	"move" : 30.0
}

export var target_coef_mod : Dictionary = {
	"ally": -50.0,
	"enemy": 30.0,
	"obstacle": 10.0
}

export var attack_result_coef_mod : Dictionary = {
	"kill": 30.0,
	"low_hp": 15.0,
	"high_damage": 10.0
}

#### ACCESSORS ####

func is_class(value: String): return value == "IA_Strategy" or .is_class(value)
func get_class() -> String: return "IA_Strategy"


#### BUILT-IN ####



#### VIRTUALS ####

func wait(actor: TRPG_Actor, _map: CombatIsoMap) -> Array:
	return [ActorActionRequest.new(actor, "wait")]

func attack(_actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	return []

func move(_actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	return []

#### LOGIC ####


func choose_best_action(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var biggest_coef = -INF
	var best_action_name = ""
	
	for key in default_coef.keys():
		var current_coef = default_coef[key]
		if current_coef > biggest_coef:
			biggest_coef = current_coef
			best_action_name = key
	
	return callv(best_action_name, [actor, map])

#### INPUTS ####



#### SIGNAL RESPONSES ####
