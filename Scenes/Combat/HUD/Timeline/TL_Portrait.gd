extends Position2D

onready var portrait_node = $Portrait

func set_portrait_texture(portrait : Texture):
	portrait_node.set_texture(portrait)
