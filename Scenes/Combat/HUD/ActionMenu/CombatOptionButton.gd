extends MenuOptionsBase
class_name CombatOptionButton


#### BUILT-IN ####

func _ready():
	var _err = connect("button_up", self, "on_pressed")


# Notify the CombatState node which button has been pressed
func on_pressed():
	EVENTS.emit_signal("actor_action_chosen", name)

