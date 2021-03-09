extends MenuOptionsBase
class_name CombatOptionButton

onready var tween = $Tween
onready var default_margin_left = get_margin(MARGIN_LEFT)

export var transition_duration : float = 0.2
export var hidden : bool = true setget set_hidden, is_hidden
export var hidden_margin_left : float = 30.0

#### ACCESSORS ####

func set_hidden(value: bool): hidden = value
func is_hidden() -> bool: return hidden


#### BUILT-IN ####


func _ready() -> void:
	if is_hidden():
		set_margin(MARGIN_LEFT, hidden_margin_left)
		set_modulate(Color.transparent)


#### LOGIC ####

func appear():
	tween.interpolate_property(self, "modulate",
		Color.transparent, Color.white, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "margin_left",
		hidden_margin_left, default_margin_left, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	set_hidden(false)


func disappear():
	tween.interpolate_property(self, "modulate",
		Color.white, Color.transparent, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "margin_left",
		default_margin_left, hidden_margin_left, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	set_hidden(true)
