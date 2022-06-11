extends Control
class_name MapEditorSaveMenu

onready var save_button = $VBoxContainer/SaveMap
onready var load_button = $VBoxContainer/LoadMap
onready var browse_button = $VBoxContainer/SaveMapAs
onready var browse_dialog = $BrowseDialog

signal save_map(path)
signal load_map(path)
signal load_last_map()

#### ACCESSORS ####

func is_class(value: String): return value == "MapEditorSaveMenu" or .is_class(value)
func get_class() -> String: return "MapEditorSaveMenu"


#### BUILT-IN ####

func _ready() -> void:
	var __ = browse_dialog.connect("dir_selected", self, "_on_browse_dialog_dir_selected")
	__ = browse_dialog.connect("file_selected", self, "_on_browse_dialog_file_selected")
	
	for button in $VBoxContainer.get_children():
		__ = button.connect("pressed", self, "_on_button_pressed", [button])


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_button_pressed(button: Button) -> void:
	match(button.name):
		"SaveMap": 
			emit_signal("save_map" , "")
		"LoadMap":
			browse_dialog.popup_centered()
			browse_dialog.set_mode(FileDialog.MODE_OPEN_FILE)
			browse_dialog.set_filters(PoolStringArray(["*.tscn"]))
		"SaveMapAs":
			browse_dialog.popup_centered()
			browse_dialog.set_mode(FileDialog.MODE_OPEN_DIR)
			browse_dialog.set_filters(PoolStringArray([]))
		"LoadLastMap":
			emit_signal("load_last_map")


func _on_browse_dialog_dir_selected(dir: String) -> void:
	emit_signal("save_map", dir)


func _on_browse_dialog_file_selected(file_path: String) -> void:
	emit_signal("load_map", file_path)
