extends Object
class_name ActorCombatState

var max_hp : int = 0
var hp : int = 0

var max_mp : int = 0
var mp : int = 0

var ailments = []

#### ACCESSORS ####

func is_class(value: String): return value == "ActorCombatState" or .is_class(value)
func get_class() -> String: return "ActorCombatState"


#### BUILT-IN ####

func _init(_hp: int, _max_hp: int, _mp: int, _max_mp: int, _ailments: Array) -> void:
	hp = _hp
	max_hp = _max_hp
	mp = _mp
	max_mp = _max_mp
	ailments = _ailments

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
