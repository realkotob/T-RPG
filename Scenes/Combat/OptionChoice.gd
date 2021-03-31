extends StateBase

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	EVENTS.emit_signal("option_choice_state_entered")


#### LOGIC ####


#### INPUTS ####


func on_cancel_input():
	if !is_current_state(): return
	
	EVENTS.emit_signal("menu_cancel")

#### SIGNAL RESPONSES ####
