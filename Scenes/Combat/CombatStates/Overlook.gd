extends CombatStateBase

#### COMBAT OVERLOOK STATE ####

#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	var _err = Events.connect("cursor_cell_changed", self, "on_cursor_changed_cell")

#### VIRTUALS ####

# Called when the current state of the state machine is set to this node
func enter_state():
	var actor_height = owner.active_actor.get_height()
	owner.HUD_node.update_height(actor_height)
	
	# Update the actions
	if owner.active_actor is Ally:
		var move = can_move()
		var attack = can_attack()
		var skill = can_use_skill()
		var item = can_use_item()
		var wait = can_wait()
		
		owner.HUD_node.update_unabled_actions(move, attack, skill, item, wait)
	else:
		owner.HUD_node.set_every_action_disabled()


# Called when the current state of the state machine is switched to another one
func exit_state():
	pass


#### SIGNAL RESPONSES ####

# Adapt the cursor color
func on_cursor_changed_cell(cursor: Cursor):
	if get_parent().get_state() != self:
		return
	
	cursor.change_color(Color.white)


#### LOGIC ####

# Check if the actor can move
func can_move() -> bool:
	return true

# Check if the actor can attack (ie if a target is reachable)
func can_attack() -> bool:
	return true
#	return owner.map_node.has_target_reachable(owner.active_actor)

func can_use_item() -> bool:
	return true

func can_use_skill() -> bool:
	return true

# Check if the active actor can move
func can_wait() -> bool:
	return owner.active_actor.get_current_actions() >= owner.active_actor.get_max_actions()
