extends MenuOptionsBase
class_name CombatOptionButton

onready var tween = $Tween


#### ACCESSORS ####

func set_visible(value: bool):
	if value != visible:
		visible = value
		if is_ready:
			if visible:
				appear()
			else:
				disappear()


#### BUILT-IN ####




#### LOGIC ####

func appear():
	tween.interpolate_property(self, "modulate",
		Color.transparent, Color.white, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "margin_left",
		30, 0, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()

func disappear():
	tween.interpolate_property(self, "modulate",
		Color.white, Color.transparent,0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "margin_left",
		0, 30, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
