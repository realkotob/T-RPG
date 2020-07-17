extends CombatStateBase

#### COMBAT ATTACK STATE ####

#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	var _err = cursor_node.connect("cell_changed", self, "on_cursor_changed_cell")


#### VIRTUAL FUNCTIONS ####

func enter_state():
	generate_reachable_aera()
	on_cursor_changed_cell(Vector3.ZERO)
	HUD_node.set_every_option_disabled()


func exit_state():
	area_node.clear()


#### LOGIC ####

# Order the area to draw the reachable cells
func generate_reachable_aera():
	var actor_cell = active_actor.get_current_cell()
	var actor_range = active_actor.get_current_attack_range()
	var reachables = map_node.get_cells_in_range(actor_cell, actor_range)
	map_node.area_node.draw_area(reachables, 1)


# Target choice
func _unhandled_input(event):
	if event is InputEventMouseButton && get_parent().get_state() == self:
		if event.get_button_index() == BUTTON_LEFT && event.pressed:
			if is_cursor_on_target():
				print("Touched")


# Return true if the cursor is on a cell where a target is
# Return false if not
func is_cursor_on_target() -> bool:
	var cursor_cell = cursor_node.get_current_cell()
	var obj = map_node.get_object_on_cell(cursor_cell)
	return cursor_cell in area_node.get_area_cells() && obj


#### SIGNAL RESPONSES ####

# Adapt the cursor color
func on_cursor_changed_cell(_cursor_cell : Vector3):
	if get_parent().get_state() != self:
		return
	
	if is_cursor_on_target():
		cursor_node.change_color(Color.white)
	else:
		cursor_node.change_color(Color.red)
