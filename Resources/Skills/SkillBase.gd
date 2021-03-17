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

enum STATE_MODIFIER_MODE {
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

export var skill_name : String = ""
export var skill_icon : Texture = null
export var cost_type : int = COST_TYPE.MP
export var cost : int = 0

export var damage_type : int = DAMAGE_TYPE.MAGIC
export var damage_amount : int = 0

export var state_modifier_array := PoolStringArray()
export var state_modifier_mode : int = STATE_MODIFIER_MODE.ADD_EVERY_STATE

export var aoe_type : int = AOE_TYPE.CIRCLE
export var aoe_size : int = 1

export var skill_range : int = 1

export var icon_texture : Texture = null

export var description : String = ""


func fetch_description_data() -> Array:
	return [
		NormalLineData.new(skill_name, skill_icon, cost),
#		NormalLineDataContainer.new(damage_type, null, damage_amount),
		NormalLineData.new(description, null, int(INF))
#		IconLineDataContainer.new()
	]
