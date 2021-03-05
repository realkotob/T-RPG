extends CombatStateBase

#### COMBAT SKILLS STATE ####


func enter_state():
	EVENTS.emit_signal("add_action_submenu", ["Pouet", "Prout", "Ploup"], name)
