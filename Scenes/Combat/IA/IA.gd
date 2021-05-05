extends Node
class_name IA

#### ACCESSORS ####

func is_class(value: String): return value == "IA" or .is_class(value)
func get_class() -> String: return "IA"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func make_decision(actor: TRPG_Actor, _map: IsoMap) -> ActorActionRequest:
	var action = ActorActionRequest.new(actor, "wait")
	return action

#### INPUTS ####



#### SIGNAL RESPONSES ####
