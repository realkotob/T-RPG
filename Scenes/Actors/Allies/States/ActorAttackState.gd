extends TRPG_ActionState
class_name TRPG_ActorAttackState

#### ACCESSORS ####

func is_class(value: String): return value == "ActorAttackState" or .is_class(value)
func get_class() -> String: return "ActorAttackState"


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state() -> void:
	.enter_state()


func exit_state() -> void:
	.exit_state()


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
