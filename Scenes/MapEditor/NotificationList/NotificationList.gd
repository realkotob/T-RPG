extends Control
class_name NotificationList

#### ACCESSORS ####

func is_class(value: String): return value == "NotificationList" or .is_class(value)
func get_class() -> String: return "NotificationList"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func push_notification(text: String, duration: float = 1.0) -> void:
	var notif = NotificationLabel.new(text, duration)
	$VBoxContainer.add_child(notif)



#### INPUTS ####



#### SIGNAL RESPONSES ####
