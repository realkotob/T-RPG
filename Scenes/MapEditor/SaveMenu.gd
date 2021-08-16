extends Control
class_name MapEditorSaveMenu

onready var save_button = $VBoxContainer/SaveMap
onready var load_button = $VBoxContainer/LoadMap
onready var browse_button = $VBoxContainer/SaveMapAs
onready var browse_dialog = $BrowseDialog

signal save_map(path)
signal load_map(path)

#### ACCESSORS ####

func is_class(value: String): return value == "MapEditorSaveMenu" or .is_class(value)
func get_class() -> String: return "MapEditorSaveMenu"


#### BUILT-IN ####

func _ready() -> void:
	var __ = save_button.connect("button_down", self, "_on_save_button_pressed")
	__ = load_button.connect("button_down", self, "_on_load_button_pressed")
	__ = browse_button.connect("button_down", self, "_on_browse_button_pressed")
	__ = browse_dialog.connect("dir_selected", self, "_on_browse_dialog_dir_selected")
	__ = browse_dialog.connect("file_selected", self, "_on_browse_dialog_file_selected")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_save_button_pressed() -> void:
	 emit_signal("save_map" , "")


func _on_browse_button_pressed() -> void:
	browse_dialog.popup_centered()
	browse_dialog.set_mode(FileDialog.MODE_OPEN_DIR)
	browse_dialog.set_filters(PoolStringArray([]))


func _on_load_button_pressed() -> void:
	browse_dialog.popup_centered()
	browse_dialog.set_mode(FileDialog.MODE_OPEN_FILE)
	browse_dialog.set_filters(PoolStringArray(["*.tscn"]))


func _on_browse_dialog_dir_selected(dir: String) -> void:
	emit_signal("save_map", dir)


func _on_browse_dialog_file_selected(file_path: String) -> void:
	emit_signal("load_map", file_path)
