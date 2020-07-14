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


# Called when the current state of the state machine is switched to another one
func exit_state():
	pass

# Adapt the cursor color
func on_cursor_changed_cell(_cursor_cell : Vector3):
	if get_parent().get_state() != self:
		return
	
	cursor_node.change_color(Color.white)
