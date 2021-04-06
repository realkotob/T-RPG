extends CombatStateBase
class_name TargetChoiceState

var map : CombatIsoMap = null

var combat_effect_obj : CombatEffectObject = null setget set_combat_effect_obj, get_combat_effect_obj

var reachables := PoolVector3Array()
var target_area := PoolVector3Array()
var square_dir : int = 0

enum AREA_TYPE {
	REACHABLE,
	EFFECT
}

#### ACCESSORS ####

func is_class(value: String): return value == "TargetChoiceState" or .is_class(value)
func get_class() -> String: return "TargetChoiceState"

func set_combat_effect_obj(value: CombatEffectObject):
	 combat_effect_obj = value
func get_combat_effect_obj() -> CombatEffectObject : return combat_effect_obj 

#### BUILT-IN ####

func _ready():
	var _err = EVENTS.connect("cursor_cell_changed", self, "on_cursor_changed_cell")
	
	yield(owner, "ready")
	
	map = owner.map_node

#### VIRTUALS ####

func enter_state():
	if combat_effect_obj == null or combat_effect_obj.aoe == null:
		print_debug("No aoe data was provided, returning to previous state")
		states_machine.go_to_previous_state()
	
	generate_area(AREA_TYPE.REACHABLE)
	EVENTS.emit_signal("target_choice_state_entered")


func exit_state():
	combat_loop.area_node.clear()
	reachables = PoolVector3Array()
	highlight_targets(false)
	target_area = PoolVector3Array()
	set_combat_effect_obj(null)


#### LOGIC ####


func generate_area(area_type: int):
	var active_actor : Actor = combat_loop.active_actor
	var actor_cell = active_actor.get_current_cell()
	
	var cursor = owner.cursor_node
	var cursor_cell = cursor.get_current_cell()
	
	var dir = IsoLogic.iso_dir(actor_cell, cursor_cell)
	var aoe = combat_effect_obj.aoe
	var aoe_size = aoe.area_size
	var aoe_range = aoe.range_size
	
	var cells_in_range := PoolVector3Array()
	
	var area_type_name = "view" if area_type == AREA_TYPE.REACHABLE else "damage"
	
	if area_type == AREA_TYPE.REACHABLE:
		match(aoe.area_type.name):
			"LineForward": cells_in_range = map.get_cells_in_straight_line(actor_cell, aoe_size, range(4))
			"LinePerpendicular": cells_in_range = map.get_cells_in_circle(actor_cell, 1)
			"Circle", "Square": cells_in_range = map.get_cells_in_circle(actor_cell, aoe_range)
		
		reachables = cells_in_range
		
	elif area_type == AREA_TYPE.EFFECT:
		match(aoe.area_type.name):
			"LineForward": cells_in_range = map.get_cells_in_straight_line(actor_cell, aoe_size, dir)
			"LinePerpendicular": cells_in_range = map.get_cell_in_perpendicular_line(actor_cell, aoe_size, dir)
			"Circle": cells_in_range = map.get_cells_in_circle(cursor_cell, aoe_size)
			"Square": cells_in_range = map.get_cells_in_square(cursor_cell, aoe_size, square_dir)
		
		target_area = cells_in_range
	
	combat_loop.area_node.draw_area(cells_in_range, area_type_name)



# Highlight, or unhighligh targeted Object/Actor on the target_area_
func highlight_targets(is_targeted: bool):
	if combat_effect_obj == null:
		return
	
	for target in get_target_in_area():
		if target == null:
			continue
		
		target.set_targeted(is_targeted, combat_effect_obj.possitive)


# SHOULD BE IN A STATIC CLASS
# Return the amount of damage the attacker inflict to the target
func compute_damage(attacker: Actor, target: DamagableObject) -> int:
	var att = attacker.get_weapon().get_attack()
	var def = target.get_defense()
	
	return int(clamp(att - def, 0.0, INF))


func get_target_in_area():
	var targets = Array()
	for cell in target_area:
		var obj = map.get_object_on_cell(cell)
		if obj != null:
			targets.append(obj)
	
	return targets


#### INPUTS ####

# Target choice
func _unhandled_input(event):
	if event is InputEventMouseButton && is_current_state():
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			
			var active_actor = combat_loop.active_actor
			var active_actor_cell = active_actor.get_current_cell()
			var targets_array = get_target_in_area()
			var cursor_cell = owner.cursor_node.get_current_cell()
			
			if targets_array == []:
				return
			
			# Trigger the attack
			for target in targets_array:
				var damage_array = CombatEffectCalculation.compute_damage(combat_effect_obj, active_actor, target)
				
				for damage in damage_array:
					combat_loop.instance_damage_label(damage, target)
					target.hurt(damage)
				
				var direction = IsoLogic.get_cell_direction(active_actor_cell, cursor_cell)
				active_actor.set_direction(direction)
				active_actor.set_state("Attack")
				
				# SHOULDN'T BE HERE
				combat_loop.active_actor.decrement_current_action()
				
				if target != active_actor:
					yield(target, "hurt_animation_finished")
			
			EVENTS.emit_signal("actor_action_animation_finished", active_actor)
		
		elif Input.is_action_just_pressed("rotateCW"):
			square_dir = wrapi(square_dir + 1, 0, 4)
			
		elif Input.is_action_just_pressed("rotateCCW"):
			square_dir = wrapi(square_dir - 1, 0, 4)


func on_cancel_input():
	if !is_current_state(): 
		return
	
	states_machine.go_to_previous_state()


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
