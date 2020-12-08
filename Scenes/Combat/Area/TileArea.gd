extends IsoObject
class_name TileArea

func _ready():
	$Sprite.set_visible(false)

func create():
	pass

func destroy():
	if is_in_group("IsoObject"):
		remove_from_group("IsoObject")
	queue_free()
