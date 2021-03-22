extends Resource
class_name Skill

enum DAMAGE_TYPE {
	PHYSICAL,
	MAGIC
}

enum COST_TYPE {
	HP,
	MP
}

enum AILMENT_MODE {
	ADD_RANDOM_STATE,
	ADD_EVERY_STATE,
	REMOVE_RANDOM_STATE,
	REMOVE_EVERY_STATE
}

enum AOE_TYPE {
	CIRCLE,
	SQUARE,
	CROSS,
	STRAIGHT_LINE,
	PERPENDICULAR_LINE
}

export var name : String = ""
export var icon : Texture = null
export var cost_type : int = COST_TYPE.MP
export var cost : int = 0

export var damage_type : int = DAMAGE_TYPE.MAGIC
export var damage_amount : int = 0

export var ailment_array : Array = []
export var ailment_mode : int = AILMENT_MODE.ADD_EVERY_STATE

export var aoe_type : int = AOE_TYPE.CIRCLE
export var aoe_size : int = 1

export var skill_range : int = 1

export var icon_texture : Texture = null

export var description : String = ""


func get_ailment_icons() -> Array:
	var icon_array : Array = []
	for ailment in ailment_array:
		icon_array.append(ailment.icon)
	
	return icon_array


func fetch_description_data() -> Array:
	return [
		NormalLineData.new(name, icon, cost),
#		NormalLineDataContainer.new(damage_type, null, damage_amount),
		NormalLineData.new(description),
		IconsLineData.new(get_ailment_icons())
#		IconLineDataContainer.new()
	]
