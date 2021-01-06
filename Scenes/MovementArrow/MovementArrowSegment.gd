extends IsoObject
class_name MovementArrowSegment

const straight_lines_texture_pos = Vector2.ZERO
const turn_texture_pos = Vector2(0, GAME.TILE_SIZE.y)
const arrow_texture_pos = Vector2(GAME.TILE_SIZE.x * 2 , 0)

var previous_segment_dir := Vector2.INF setget set_previous_segment_dir, get_previous_segment_dir
var next_segment_dir := Vector2.INF setget set_next_segment_dir, get_next_segment_dir

#### ACCESSORS ####

func is_class(value: String): return value == "MovementArrowSegment" or .is_class(value)
func get_class() -> String: return "MovementArrowSegment"

func set_previous_segment_dir(value: Vector2): previous_segment_dir = value
func get_previous_segment_dir() -> Vector2: return previous_segment_dir

func set_next_segment_dir(value: Vector2): next_segment_dir = value
func get_next_segment_dir() -> Vector2: return next_segment_dir

#### BUILT-IN ####

func _enter_tree() -> void:
	apply_correct_texture()

#### VIRTUALS ####



#### LOGIC ####

func apply_correct_texture():
	var tile_size = GAME.TILE_SIZE
	var rect_pos = Vector2.ZERO
	
	if is_path_end():
		match(previous_segment_dir):
			Vector2.LEFT: rect_pos = arrow_texture_pos
			Vector2.UP: rect_pos = arrow_texture_pos + Vector2(tile_size.x, 0)
			Vector2.RIGHT: rect_pos = arrow_texture_pos + tile_size
			Vector2.DOWN: rect_pos = arrow_texture_pos + Vector2(0, tile_size.y)
	elif is_straight_line():
		match(next_segment_dir):
			Vector2.LEFT, Vector2.RIGHT: rect_pos = Vector2.ZERO
			Vector2.UP, Vector2.DOWN: rect_pos = Vector2(tile_size.x, 0)
	else:
		
		#### TO REFACTO - USE A BITMASK ### 
		if previous_segment_dir == Vector2.UP or next_segment_dir == Vector2.UP:
			if previous_segment_dir == Vector2.LEFT or next_segment_dir == Vector2.LEFT:
				rect_pos = turn_texture_pos + tile_size
			elif previous_segment_dir == Vector2.RIGHT or next_segment_dir == Vector2.RIGHT:
				rect_pos = turn_texture_pos + Vector2(tile_size.x, 0)
		elif previous_segment_dir == Vector2.DOWN or next_segment_dir == Vector2.DOWN:
			if previous_segment_dir == Vector2.LEFT or next_segment_dir == Vector2.LEFT:
				rect_pos = turn_texture_pos
			elif previous_segment_dir == Vector2.RIGHT or next_segment_dir == Vector2.RIGHT:
				rect_pos = turn_texture_pos + Vector2(0, tile_size.y)
				
	$Sprite.set_region_rect(Rect2(rect_pos, tile_size))


func is_path_end():
	return next_segment_dir == Vector2.INF


func is_straight_line() -> bool:
	return (previous_segment_dir.x + next_segment_dir.x == 0 &&\
		previous_segment_dir.y + next_segment_dir.y == 0) or \
		previous_segment_dir == Vector2.INF


#### INPUTS ####



#### SIGNAL RESPONSES ####
