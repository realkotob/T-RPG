extends Resource
class_name Ailment

enum EFFECT_TRIGGER {
	TURN_START
	TURN_END,
	ACTION_SPENT,
	ATTACK,
	MOVE
}

export var name : String = ""
export var icon : Texture = null
export var effect_trigger : int = EFFECT_TRIGGER.TURN_START

export var nb_turns : int = -1
var current_turns_left : int = nb_turns

#### ACCESSORS ####

func is_class(value: String): return value == "Ailment" or .is_class(value)
func get_class() -> String: return "Ailment"


#### VIRTUALS ####

func effect():
	pass
