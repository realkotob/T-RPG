extends StateBase

onready var combat_loop = owner

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### BUILT-IN ####

func _ready():
	var _err = EVENTS.connect("cursor_cell_changed", self, "on_cursor_changed_cell")

#### VIRTUALS ####

func enter_state():
	generate_reachable_aera()
	EVENTS.emit_signal("target_choice_state_entered")


func exit_state():
	combat_loop.area_node.clear()


#### LOGIC ####

# Target choice
func _unhandled_input(event):
	if event is InputEventMouseButton && is_current_state():
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			
			var active_actor = combat_loop.active_actor
			var active_actor_cell = active_actor.get_current_cell()
			var target = combat_loop.cursor_node.get_target()
			
			if target == null:
				return
			
			var target_cell = target.get_current_cell()
			var reachables_cells = combat_loop.area_node.get_area_cells()
			
			# Check if the target is reachable
			if !target is DamagableObject or !target_cell in reachables_cells or\
				!owner.allies_team.is_cell_in_view_field(target_cell):
				return null
			
			# Trigger the attack
			if target:
				var damage = compute_damage(active_actor, target)
				combat_loop.instance_damage_label(damage, target)
				
				var direction = IsoLogic.get_cell_direction(active_actor_cell, target_cell)
				active_actor.set_direction(direction)
				active_actor.set_state("Attack")
				target.hurt(damage)
				combat_loop.active_actor.decrement_current_action()
				
				yield(target, "hurt_animation_finished")
				owner.emit_signal("actor_action_finished", active_actor)



# Order the area to draw the reachable cells
func generate_reachable_aera():
	var active_actor : Actor = combat_loop.active_actor
	var actor_cell = active_actor.get_current_cell()
	var actor_range = active_actor.get_current_range()
	var actor_height = active_actor.get_height()
	var reachables = combat_loop.map_node.get_reachable_cells(actor_cell, actor_height, actor_range)
	combat_loop.area_node.draw_area(reachables, "damage")



# SHOULD BE IN A STATIC CLASS
# Return the amount of damage the attacker inflict to the target
func compute_damage(attacker: Actor, target: DamagableObject) -> int:
	var att = attacker.get_weapon().get_attack()
	var def = target.get_defense()
	
	return int(clamp(att - def, 0.0, INF))



#### INPUTS ####

func on_cancel_input():
	if !is_current_state(): return
	
	states_machine.go_to_previous_state()


#### SIGNAL RESPONSES ####


# Adapt the cursor color
func on_cursor_changed_cell(cursor : Cursor, _cell: Vector3):
	if !is_current_state():
		return
	
	if combat_loop.cursor_node.get_target() != null:
		cursor.change_color(Color.white)
	else:
		cursor.change_color(Color.red)
