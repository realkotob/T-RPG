extends CombatStateBase
class_name TargetChoiceState

var map = null

var aoe : AOE = null setget set_aoe, get_aoe
var positive : bool = false

var reachables := PoolVector3Array()
var target_area := PoolVector3Array()
var square_dir : int = 0

var aoe_target : AOE_Target = null

enum AREA_TYPE {
	REACHABLE,
	EFFECT
}

signal target_chosen(aoe_targ)

#### ACCESSORS ####

func is_class(value: String): return value == "TargetChoiceState" or .is_class(value)
func get_class() -> String: return "TargetChoiceState"

func set_aoe(value: AOE): aoe = value
func get_aoe() -> AOE : return aoe 

#### BUILT-IN ####

func _ready():
	var _err = EVENTS.connect("cursor_cell_changed", self, "on_cursor_changed_cell")
	
	yield(owner, "ready")
	
	map = owner.map_node

#### VIRTUALS ####

func enter_state():
	if !is_current_state(): return
	
	if aoe == null:
		push_error("No aoe data was provided, returning to previous state")
		states_machine.go_to_previous_state()
		return
	
	generate_area(AREA_TYPE.REACHABLE)
	EVENTS.emit_signal("target_choice_state_entered")


func exit_state():
	highlight_targets(false)
	combat_loop.area_node.clear()
	reachables = PoolVector3Array()
	target_area = PoolVector3Array()
	set_aoe(null)
	positive = false


#### LOGIC ####


func generate_area(area_type: int):
	var active_actor : TRPG_Actor = combat_loop.active_actor
	var actor_cell = active_actor.get_current_cell()
	
	var cursor = owner.cursor_node
	var cursor_cell = cursor.get_current_cell()
	
	var aoe_size = aoe.area_size
	var aoe_range = aoe.range_size
	
	aoe_target = AOE_Target.new(actor_cell, cursor_cell, aoe, square_dir)
	
	var cells_in_range := PoolVector3Array()
	var area_type_name = "view" if area_type == AREA_TYPE.REACHABLE else "damage"
	
	if area_type == AREA_TYPE.REACHABLE:
		match(aoe.area_type.name):
			"LineForward": cells_in_range = map.get_cells_in_straight_line(actor_cell, aoe_size, range(4))
			"LinePerpendicular": cells_in_range = map.get_walkable_cells_in_circle(actor_cell, 2, true)
			"Circle", "Square": cells_in_range = map.get_walkable_cells_in_circle(actor_cell, aoe_range + 1, true)
		
		reachables = cells_in_range
	
	elif area_type == AREA_TYPE.EFFECT:
		cells_in_range = map.get_cells_in_area(aoe_target)
		target_area = cells_in_range
	
	combat_loop.area_node.draw_area(cells_in_range, area_type_name)



# Highlight, or unhighligh targeted Object/TRPG_Actor on the target_area
func highlight_targets(is_targeted: bool):
	if aoe == null:
		return
	
	for target in owner.map_node.get_objects_in_area(target_area):
		if target == null:
			continue
		
		target.set_targeted(is_targeted, positive)


#### INPUTS ####

# Target choice
func _unhandled_input(event):
	if event is InputEventMouseButton && is_current_state():
		if event.get_button_index() == BUTTON_LEFT && event.pressed && aoe_target != null:
			emit_signal("target_chosen", aoe_target)
		
		elif Input.is_action_just_pressed("rotateCW"):
			square_dir = wrapi(square_dir + 1, 0, 4)
			
		elif Input.is_action_just_pressed("rotateCCW"):
			square_dir = wrapi(square_dir - 1, 0, 4)


func on_cancel_input():
	if !is_current_state(): 
		return
	
	if get_index() != 0:
		states_machine.go_to_previous_state()
	else:
		owner.set_turn_state("Overlook")


#### SIGNAL RESPONSES ####


# Adapt the cursor color
func on_cursor_changed_cell(cursor : Cursor, cell: Vector3):
	if !is_current_state():
		return
	
	if combat_loop.cursor_node.get_target() != null:
		cursor.change_color(Color.white)
	else:
		cursor.change_color(Color.red)
	
	owner.area_node.clear("damage")
	highlight_targets(false)
	
	if cell in reachables:
		generate_area(AREA_TYPE.EFFECT)
		highlight_targets(true)
