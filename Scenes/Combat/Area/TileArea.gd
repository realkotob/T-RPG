extends IsoObject
class_name TileArea

func _ready():
	$Sprite.set_visible(false)

func create():
	pass

func destroy():
	remove_from_group("IsoObject")
	queue_free()
