extends Tween
class_name IsoObjectTween

signal flash_finished

#### ACCESSORS ####

func is_class(value: String): return value == "IsoObjectTween" or .is_class(value)
func get_class() -> String: return "IsoObjectTween"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func flash(color: Color, duration: float = 0.5, trans_type : int = TRANS_LINEAR) -> void:
	var initial_modulate = owner.get_modulate()
	
	for i in range(2):
		var start = initial_modulate if i == 0 else color
		var dest = color if i == 0 else initial_modulate
		var __ = interpolate_method(owner, "change_modulate_color", start, dest, duration / 2,
			trans_type, Tween.EASE_IN)
		
		__ = start()
		yield(self, "tween_all_completed")
	
	emit_signal("flash_finished")


#### INPUTS ####



#### SIGNAL RESPONSES ####
