extends Label


func _ready():
	var tween_node : Tween = get_node("Tween")
	tween_node.interpolate_property(self, "scale",
			Vector2(1, 1), Vector2(2, 2), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()
	
	yield(tween_node, "tween_all_completed")
	
	tween_node.interpolate_property(self, "scale",
		get_scale(), Vector2(1, 1), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()
	
	yield(tween_node, "tween_all_completed")
	
	tween_node.interpolate_property(self, "modulate",
		Color.white, Color.transparent, 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()
	
	yield(tween_node, "tween_all_completed")
	
	queue_free()
