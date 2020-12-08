extends Node2D

onready var debris = preload("res://Global/Autoloads/Debris.tscn")

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func scatter_sprite(node: Node2D, nb_debris : int, impulse_force: float = 100.0):
	var sprite = node.get_node_or_null("Sprite")
	var texture
	var region_rect
	
	if sprite == null:
		sprite = node.get_node_or_null("AnimatedSprite")
		var current_anim = sprite.get_animation()
		var current_frame = sprite.get_frame()
		texture = sprite.get_sprite_frames().get_frame(current_anim, current_frame)
		region_rect = Rect2(Vector2.ZERO, texture.get_size())
	else:
		texture = sprite.get_texture()
		if sprite.is_region():
			region_rect = sprite.get_region_rect()
		else:
			region_rect = Rect2(Vector2.ZERO, texture.get_size())
	
	var body_global_pos : Vector2 = sprite.get_global_position() + sprite.get_offset()
	var body_origin : Vector2 = body_global_pos - region_rect.size / 2

	var square_size = int(sqrt((region_rect.size.x * region_rect.size.y) / nb_debris))
	
	var row_len = int(region_rect.size.x / square_size)
	var col_len = int(region_rect.size.y / square_size)
	
	for i in range(row_len):
		for j in range(col_len):
			var debris_node = debris.instance()
			var debris_sprite = debris_node.get_node("Sprite")
			var collision_shape = RectangleShape2D.new()
			collision_shape.set_extents(Vector2(square_size / 2, square_size / 2))
			
			debris_node.get_node("CollisionShape2D").set_shape(collision_shape)
			
			var global_pos = Vector2(body_origin.x + i * square_size, body_origin.y + j * square_size)
			
			debris_sprite.set_texture(texture)
			debris_sprite.set_region(true)
			debris_sprite.set_region_rect(Rect2(region_rect.position.x + i * square_size,
												region_rect.position.y + j * square_size,
												square_size, square_size))
			
			var epicenter_dir = global_pos.direction_to(body_global_pos)
			debris_node.apply_central_impulse(-(epicenter_dir * impulse_force * rand_range(0.7, 1.3)))
			
			call_deferred("add_child", debris_node)
			debris_node.call_deferred("set_global_position", global_pos)

#### INPUTS ####



#### SIGNAL RESPONSES ####
