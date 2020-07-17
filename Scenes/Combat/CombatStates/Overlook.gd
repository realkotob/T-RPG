extends CombatStateBase

#### COMBAT OVERLOOK STATE ####

func _ready():
	yield(owner, "ready")
	var _err = cursor_node.connect("cell_changed", self, "on_cursor_changed_cell")


# Called when the current state of the state machine is set to this node
func enter_state():
	var active_actor = owner.active_actor
	var actor_height = active_actor.get_height()
	owner.HUD_node.update_height(actor_height)
	
	var move = can_move()
	var attack = can_attack()
	var skill = can_use_skill()
	var item = can_use_item()
	var wait = can_wait()
	
	HUD_node.update_unabled_actions(move, attack, skill, item, wait)


# Called when the current state of the state machine is switched to another one
func exit_state():
	pass

# Adapt the cursor color
func on_cursor_changed_cell(_cursor_cell : Vector3):
	if get_parent().get_state() != self:
		return
	
	cursor_node.change_color(Color.white)

# Check if the actor can move
func can_move() -> bool:
	return true

# Check if the actor can attack (ie if a target is reachable)
func can_attack() -> bool:
	var actor_cell = active_actor.get_current_cell()
	var actor_range = active_actor.get_current_attack_range()
	var reachables = map_node.get_cells_in_range(actor_cell, actor_range)
	
	for cell in reachables:
		var obj = map_node.get_object_on_cell(cell)
		if obj is Actor or obj is Obstacle:
			if obj != active_actor:
				return true
	return false

func can_use_item() -> bool:
	return true

func can_use_skill() -> bool:
	return true

func can_wait() -> bool:
	return active_actor.get_current_actions() >= active_actor.get_max_actions()
