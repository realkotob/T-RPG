extends IsoObject
class_name MovementArrowSegment

const straight_lines_texture_pos = Vector2.ZERO
const turn_texture_pos = Vector2(0, GAME.TILE_SIZE.y)
const arrow_texture_pos = Vector2(GAME.TILE_SIZE.x * 2 , 0)
const path_start_texture_pos = Vector2(GAME.TILE_SIZE.x * 4, 0)
const slope_texture_pos = GAME.TILE_SIZE * Vector2(4, 2)

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

# Apply the correct texture based on the direction of the previous and the next segement
func apply_correct_texture():
	var tile_size = GAME.TILE_SIZE
	var rect_pos = Vector2.ZERO
	
	if is_straight_line():
		if !is_slope():
			match(next_segment_dir):
				Vector2.LEFT, Vector2.RIGHT: rect_pos = Vector2.ZERO
				Vector2.UP, Vector2.DOWN: rect_pos = Vector2(tile_size.x, 0)
		else:
			tile_size *= Vector2(1, 2) 
			match(next_segment_dir):
				Vector2.LEFT, Vector2.RIGHT: rect_pos = slope_texture_pos
				Vector2.UP, Vector2.DOWN: rect_pos = slope_texture_pos + Vector2(tile_size.x, 0)
	else:
		var to_check := Vector2.INF
		var start_pos := Vector2.ZERO
		var offset := Vector2.ZERO
		
		if is_path_start():
			to_check = next_segment_dir
			start_pos = path_start_texture_pos
		elif is_path_end():
			to_check = previous_segment_dir
			start_pos = arrow_texture_pos
		else:
			start_pos = turn_texture_pos
			
			if is_one_dir(Vector2.UP):
				if is_one_dir(Vector2.LEFT):
					offset = tile_size
				elif is_one_dir(Vector2.RIGHT):
					offset = Vector2(tile_size.x, 0)
			elif is_one_dir(Vector2.DOWN):
				if is_one_dir(Vector2.RIGHT):
					offset = Vector2(0, tile_size.y)
		
		match(to_check):
			Vector2.UP: offset = Vector2(tile_size.x, 0)
			Vector2.RIGHT: offset = tile_size
			Vector2.DOWN: offset = Vector2(0, tile_size.y)
		
		rect_pos = start_pos + offset
	
	$Sprite.set_region_rect(Rect2(rect_pos, tile_size))


func is_slope():
	return int(current_cell.z) != current_cell.z


func is_one_dir(dir: Vector2):
	return previous_segment_dir == dir or next_segment_dir == dir


func is_path_end():
	return next_segment_dir == Vector2.INF


func is_path_start():
	return previous_segment_dir == Vector2.INF


func is_straight_line() -> bool:
	return (previous_segment_dir.x + next_segment_dir.x == 0 &&\
		previous_segment_dir.y + next_segment_dir.y == 0)


func change_segment_dir(previous := Vector2.INF, next := Vector2.INF) -> void:
	if previous == previous_segment_dir && next == next_segment_dir:
		return
	
	set_previous_segment_dir(previous)
	set_next_segment_dir(next)
	apply_correct_texture()



#### INPUTS ####



#### SIGNAL RESPONSES ####
