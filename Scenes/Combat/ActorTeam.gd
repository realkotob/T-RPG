extends Node2D
class_name ActorTeam

enum TEAM_TYPE{
	ALLY,
	ENEMY
}

var map_knowledge_array = []
var map = null

export var IA_controled : bool = false

export(TEAM_TYPE) var team_side = TEAM_TYPE.ENEMY setget set_team_side, get_team_side
export var inventory := Array() setget set_inventory, get_inventory

#### ACCESSORS ####

func is_class(value: String): return value == "ActorTeam" or .is_class(value)
func get_class() -> String: return "ActorTeam"

func set_inventory(value: Array): inventory = value
func get_inventory() -> Array: return inventory

func set_team_side(value: int): 
	if value < TEAM_TYPE.size() && value >= 0:
		team_side = value
	else:
		push_warning("The passed value %d isn't valid. The given value should be a member of TEAM_TYPE" % value)

func get_team_side() -> int: return team_side
func is_team_side(value: int) -> bool: return value == team_side

#### BUILT-IN ####

func _ready() -> void:
	var _err = EVENTS.connect("visible_cells_changed", self, "_on_visible_cells_changed")
	_err = EVENTS.connect("IA_overlook_begun", self, "_on_IA_overlook_begun")
	
	for child in get_children():
		child.add_to_group(name)


#### VIRTUALS ####


#### LOGIC ####


func update_view_field_rendering() -> void:
	var team_view_field = get_view_field()
	
	# Give every objects its visibility
	for obj in get_tree().get_nodes_in_group("IsoObject"):
		var obj_cell = obj.get_current_cell()
		var visibility = IsoObject.VISIBILITY.VISIBLE
		
		if obj_cell in team_view_field[IsoObject.VISIBILITY.BARELY_VISIBLE]:
			visibility = IsoObject.VISIBILITY.BARELY_VISIBLE
		
		elif not obj_cell in team_view_field[IsoObject.VISIBILITY.VISIBLE]:
			if obj.is_class("TRPG_Actor") && obj.is_team_side(TEAM_TYPE.ENEMY):
				visibility = IsoObject.VISIBILITY.HIDDEN
			else:
				visibility = IsoObject.VISIBILITY.NOT_VISIBLE
		
		obj.set_visibility(visibility)
	
	EVENTS.emit_signal("update_rendered_visible_cells", team_view_field)


func is_actor_in_team(actor: TRPG_Actor) -> bool:
	for child in get_children():
		if child == actor:
			return true
	return false


func is_cell_2D_in_view_field(cell: Vector2):
	for array in get_view_field():
		for cell_3D in array:
			if cell.x == cell_3D.x && cell.y == cell_3D.y:
				return true
	return false 


func is_cell_in_view_field(cell: Vector3):
	for array in get_view_field():
		if cell in array:
			return true
	return false 


# Check if the view field of the team is empty
func is_view_field_empty() -> bool:
	for actor in get_children():
		var actor_view_field = actor.get_view_field()
		if actor_view_field.empty() or actor_view_field[0].empty():
			return true
	return false


# Returns the team view field, by adding every ally's view field
# Assure a tile can't be barely visible, if it is visible by another actor
func get_view_field() -> Array:
	var view_field = [[], []]
	
	for i in range(2):
		for actor in get_children():
			for cell in actor.get_view_field()[i]:
				if not cell in view_field[i]:
					if i != 0 && cell in view_field[IsoObject.VISIBILITY.VISIBLE]:
						continue
					view_field[i].append(cell)
	
	return view_field


func get_actors() -> Array:
	var actors_array = []
	for child in get_children():
		if child.is_class("TRPG_Actor") && is_instance_valid(child):
			actors_array.append(child)
	return actors_array


func _compute_map_segment_knowledge(segment_id : int) -> float:
	var segment_origin = map.segment_get_origin(segment_id)
	var segment_nb_tiles = map.segment_get_nb_tiles(segment_id)
	var absolute_knowledge = 0
	
	for i in range(map.MAP_SEGMENT_SIZE):
		for j in range(map.MAP_SEGMENT_SIZE):
			var cell = segment_origin + Vector2(j, i)
			if !map.has_2D_cell(cell):
				continue
			
			if is_cell_2D_in_view_field(cell):
				absolute_knowledge += 1
	
	if segment_nb_tiles == 0:
		return 0.0
	
	return float(absolute_knowledge) / segment_nb_tiles


func _update_map_knowledge() -> void:
	map_knowledge_array = []
	var nb_segments_v = map.get_nb_segments()
	var nb_segments = nb_segments_v.x * nb_segments_v.y
	for i in range(nb_segments):
		map_knowledge_array.append(_compute_map_segment_knowledge(i))


func get_segment_knowledge(seg_id: int) -> float:
	return map_knowledge_array[seg_id]



#### DEBUG ####

func _print_map_knowledge() -> void:
	if team_side == TEAM_TYPE.ALLY:
		print("## ALLY TEAM ##")
	else:
		print("## ENEMY TEAM ##")
	
	for i in range(map_knowledge_array.size()):
		print("Segment %d knowledge score %f" % [i, map_knowledge_array[i]] )


func _print_segments_origin() -> void:
	for i in range(map_knowledge_array.size()):
		var origin = map.segment_get_origin(i)
		print("Segment %s origin: %s" % [String(i), String(origin)])


#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_visible_cells_changed(actor: TRPG_Actor):
	if is_team_side(TEAM_TYPE.ALLY) && is_actor_in_team(actor):
		update_view_field_rendering()


func _on_IA_overlook_begun(actor: TRPG_Actor) -> void:
	if IA_controled && is_actor_in_team(actor):
		_update_map_knowledge()
#		_print_segments_origin()
#		_print_map_knowledge()
