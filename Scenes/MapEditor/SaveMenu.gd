extends Control
class_name MapEditorSaveMenu

onready var save_button = $VBoxContainer/SaveMap
onready var browse_button = $VBoxContainer/SaveMapAs
onready var browse_dialog = $BrowseDialog

signal save(path)

#### ACCESSORS ####

func is_class(value: String): return value == "MapEditorSaveMenu" or .is_class(value)
func get_class() -> String: return "MapEditorSaveMenu"


#### BUILT-IN ####

func _ready() -> void:
	var __ = save_button.connect("button_down", self, "_on_save_button_pressed")
	__ = browse_button.connect("button_down", self, "_on_browse_button_pressed")
	__ = browse_dialog.connect("dir_selected", self, "_on_browse_dialog_dir_selected")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_save_button_pressed() -> void:
	 emit_signal("save" , "")


func _on_browse_button_pressed() -> void:
	browse_dialog.popup_centered()


func _on_browse_dialog_dir_selected(dir: String) -> void:
	emit_signal("save", dir)
