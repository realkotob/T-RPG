extends CombatEffectObject
class_name Skill

enum DAMAGE_TYPE {
	PHYSICAL,
	MAGIC
}

enum COST_TYPE {
	HP,
	MP,
	ACTION_POINT
}

enum AILMENT_MODE {
	ADD_RANDOM_STATE,
	ADD_EVERY_STATE,
	REMOVE_RANDOM_STATE,
	REMOVE_EVERY_STATE
}

export var icon : Texture = null
export var cost_type : int = COST_TYPE.MP
export var cost : int = 0

export var damage_type : int = DAMAGE_TYPE.MAGIC
export var damage_amount : int = 0

export var ailment_array : Array = []
export var ailment_mode : int = AILMENT_MODE.ADD_EVERY_STATE

export var icon_texture : Texture = null

func get_description() -> String:
	return description.format({
		"amount": abs(damage_amount)
	})


func get_ailment_icons() -> Array:
	var icon_array : Array = []
	for ailment in ailment_array:
		icon_array.append(ailment.icon)
	
	return icon_array


func fetch_description_data() -> Array:
	return [
		NormalLineData.new(name, icon, cost),
		NormalLineData.new(get_description()),
		NormalLineData.new(aoe.area_type.name, aoe.area_type.icon, aoe.area_size),
		NormalLineData.new("range : ", null, aoe.range_size),
		IconsLineData.new(get_ailment_icons())
	]
