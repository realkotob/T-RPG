extends Label
class_name NotificationLabel

onready var tween = Tween.new()

var duration : float = 1.0

#### ACCESSORS ####

func is_class(value: String): return value == "NotificationLabel" or .is_class(value)
func get_class() -> String: return "NotificationLabel"


#### BUILT-IN ####

func _init(_text: String, dur: float) -> void:
	set_text(_text)
	duration = dur


func _ready() -> void:
	add_child(tween)
	var __ = tween.connect("tween_all_completed", self, "_on_tween_all_completed")
	
	fade_out()

#### VIRTUALS ####



#### LOGIC ####

func fade_out() -> void:
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, 
					Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, duration)
	
	tween.start()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_tween_all_completed() -> void:
	queue_free()
