extends Node2D

# Store the tile size for the entire game
# onready var TILESIZE = Vector2(32,16)

# nav_2d : Navigation2D = $Navigation2D
# onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Character
onready var tilemap : TileMap = $TileMap

func _unhandled_input(event : InputEvent) -> void:
	
	# Check if the input is mouse left button click. If not, return from the function
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		
		# Get the shortest path between the character's position and the position the user clicked on
		# var new_path : = nav_2d.get_simple_path(character.global_position, event.global_position)
		# new_path.remove(0)
		
		# Assign the path to the line 2d to draw it on screen, and to the character so it knows where to go
		# line_2d.points = new_path
		# character.path = new_path
		
		tilemap.set_path_start_position(character.global_position)
		tilemap.set_path_end_position(event.global_position)
		character.set_path(tilemap._point_path)
		print(tilemap._point_path)
		
	else:
		return