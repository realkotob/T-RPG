extends IA_Strategy
class_name SupportStrategy

enum support_obj_types{
	ITEM,
	SKILL
}


#### ACCESSORS ####

func is_class(value: String): return value == "HealStrategy" or .is_class(value)
func get_class() -> String: return "HealStrategy"


#### BUILT-IN ####



#### VIRTUALS ####

func skill(_actor: TRPG_Actor, _map: CombatIsoMap) -> Array:
	return []


func item(actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var _need_array = _find_support_needed(support_obj_types.ITEM, actor, map)
	var _support_items = _find_support_objects(support_obj_types.ITEM, actor)
	
	return []


#### LOGIC ####


func _find_support_objects(type: int, actor: TRPG_Actor) -> Array:
	var wanted_obj_type = ""
	
	match(type):
		support_obj_types.ITEM: wanted_obj_type = "items"
		support_obj_types.SKILL: wanted_obj_type = "skills"
	
	var getter = "get_%s" % wanted_obj_type
	var obj_array = actor.call(getter) if actor.has_method(getter) else actor.get(wanted_obj_type)
	var support_objs = []
	
	for obj in obj_array:
		if obj.is_support_object():
			support_objs.append(obj)
	
	return support_objs


func _find_support_needed(obj_type_used: int, actor: TRPG_Actor, map: CombatIsoMap) -> Array:
	var support_obj_array = _find_support_objects(obj_type_used, actor)
	var biggest_range = _find_biggest_range_obj(support_obj_array)
	
	var total_movement = (actor.get_current_actions() - 1) * actor.get_current_movements()
	var actors_in_range = map.get_targetables_in_range(actor, biggest_range + total_movement, Vector3.INF, true, true)
	
	var actor_need_array = []
	
	for actor in actors_in_range:
		var actor_need = _actor_get_support_need(actor)
		if actor_need != null:
			actor_need_array.append(actor_need)
	
	return actor_need_array


func _actor_get_support_need(actor: TRPG_Actor) -> ActorSupportNeed:
	var need_array = []
	for i in range(4):
		var value = 0
		
		match(i):
			SupportNeed.actor_need_type.HP: value = 1.0 - float(actor.get_current_HP()) / float(actor.get_max_HP())
			SupportNeed.actor_need_type.MP: value = 1.0 - float(actor.get_current_MP()) / float(actor.get_max_MP())
			SupportNeed.actor_need_type.RESSURECT: value = float(actor.is_dead())
			SupportNeed.actor_need_type.AILMENT: value = float(!actor.ailments.empty())
		
		if value > 0.0:
			need_array.append(SupportNeed.new(i, value))
	
	if need_array.empty():
		return null
	else:
		return ActorSupportNeed.new(actor, need_array)


func _find_biggest_range_obj(obj_array: Array) -> int:
	var biggest_range : int = 0
	
	for obj in obj_array:
		var obj_aoe = obj.aoe
		if obj_aoe == null: continue
		var obj_range = obj_aoe.range_size + obj_aoe.area_size
		if obj_range > biggest_range:
			biggest_range = obj_range
	
	return biggest_range


#### INPUTS ####



#### SIGNAL RESPONSES ####
