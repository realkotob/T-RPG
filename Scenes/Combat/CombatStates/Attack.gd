extends CombatStateBase

const DAMAGE_LABEL_SCENE := preload("res://Scenes/Combat/DamageLabel/DamageLabel.tscn")

#### COMBAT ATTACK STATE ####

#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	var _err = cursor_node.connect("cell_changed", self, "on_cursor_changed_cell")


#### VIRTUAL FUNCTIONS ####

func enter_state():
	generate_reachable_aera()
	on_cursor_changed_cell(Vector3.ZERO)
	HUD_node.set_every_action_disabled()


func exit_state():
	area_node.clear()


#### LOGIC ####

# Order the area to draw the reachable cells
func generate_reachable_aera():
	var actor_cell = active_actor.get_current_cell()
	var actor_range = active_actor.get_current_range()
	var reachables = map_node.get_cells_in_range(actor_cell, actor_range)
	map_node.area_node.draw_area(reachables, 1)


# Target choice
func _unhandled_input(event):
	if event is InputEventMouseButton && get_parent().get_state() == self:
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			
			var target = get_cursor_target()
			if target:
				var damage = compute_damage(active_actor, target)
				instance_damage_label(damage, target)
				target.hurt(damage)


func instance_damage_label(damage: int, target: DamagableObject):
	var damage_label = DAMAGE_LABEL_SCENE.instance()
	damage_label.set_global_position(target.get_global_position())
	damage_label.set_text(String(damage))
	
	owner.call_deferred("add_child", damage_label)

# Return the target designated by the cursor
func get_cursor_target() -> DamagableObject:
	var cursor_cell = cursor_node.get_current_cell()
	var object = map_node.get_object_on_cell(cursor_cell)
	if object is DamagableObject && cursor_cell in area_node.get_area_cells():
		return object
	else:
		return null


# Return the amount of damage the attacker inflict to the target
func compute_damage(attacker: Actor, target: DamagableObject) -> int:
	var att = attacker.get_weapon().get_attack()
	var def = target.get_defense()
	
	return int(clamp(def - att, 0.0, INF))


#### SIGNAL RESPONSES ####

# Adapt the cursor color
func on_cursor_changed_cell(_cursor_cell : Vector3):
	if get_parent().get_state() != self:
		return
	
	if get_cursor_target():
		cursor_node.change_color(Color.white)
	else:
		cursor_node.change_color(Color.red)
