extends DamagableObject
class_name Obstacle

func _ready():
	pass


func destroy():
	EVENTS.emit_signal("obstacle_removed", self)
	.destroy()
