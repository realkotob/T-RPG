extends Resource
class_name Effect

enum DAMAGE_TYPE {
	PHYSICAL,
	MAGIC
}

enum AILMENT_MODE {
	ADD_RANDOM_STATE,
	ADD_EVERY_STATE,
	REMOVE_RANDOM_STATE,
	REMOVE_EVERY_STATE
}

export var nb_hits = 1
export var damage : int = 0
export var damage_variance : float = 0.0

export(DAMAGE_TYPE) var damage_type : int = DAMAGE_TYPE.MAGIC

export var ailment_array : Array = []
export(AILMENT_MODE) var ailment_mode : int = AILMENT_MODE.ADD_EVERY_STATE

func is_class(value: String): return value == "Effect" or .is_class(value)
func get_class() -> String: return "Effect"
