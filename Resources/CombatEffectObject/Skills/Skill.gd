extends CombatEffectObject
class_name Skill

enum COST_TYPE {
	HP,
	MP,
	ACTION_POINT
}

export var icon : Texture = null
export var cost_type : int = COST_TYPE.MP
export var cost : int = 0

export var icon_texture : Texture = null

func get_description() -> String:
	return description.format({
		"amount": abs(effect.damage)
	})


func get_ailment_icons() -> Array:
	var icon_array : Array = []
	for ailment in effect.ailment_array:
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
