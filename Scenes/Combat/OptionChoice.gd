extends CombatStateBase
class_name OptionChoiceState

#### ACCESSORS ####

func is_class(value: String): return value == "OptionChoiceState" or .is_class(value)
func get_class() -> String: return "OptionChoiceState"


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	EVENTS.emit_signal("option_choice_state_entered")


#### LOGIC ####


#### INPUTS ####


func on_cancel_input():
	if !is_current_state(): return
	
	owner.set_state("Overlook")

#### SIGNAL RESPONSES ####
