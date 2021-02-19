tool
extends Control
class_name Jauge

onready var tween_node = $Tween
onready var progressive_jauge : TextureProgress = $ProgressiveJauge
onready var feedback_jauge : TextureProgress = $FeedbackJauge

export var jauge_color : Color = Color.white setget set_jauge_color
export var feedback_color : Color = Color.gray setget set_feedback_color

export var jauge_value : int = 100 setget set_jauge_value

#### ACCESSORS ####

func is_class(value: String): return value == "Jauge" or .is_class(value)
func get_class() -> String: return "Jauge"

func set_jauge_value(value: int):
	jauge_value = value
	
	tween_node.interpolate_property(progressive_jauge, "value",
		progressive_jauge.get_value(), value, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	tween_node.start()


func set_jauge_color(value: Color):
	progressive_jauge.set_tint_progress(value)


func set_feedback_color(value: Color):
	feedback_jauge.set_tint_progress(value)


#### BUILT-IN ####


func _ready() -> void:
	var __ = tween_node.connect("tween_completed", self, "_on_tween_completed")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_tween_completed(obj: Object, _key: String):
	if obj == progressive_jauge:
		tween_node.interpolate_property(feedback_jauge, "value",
			feedback_jauge.get_value(), progressive_jauge.get_value(), 0.1, 
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
		tween_node.start()
