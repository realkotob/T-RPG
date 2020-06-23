tool
extends EditorPlugin

const LAYER = preload("res://Scenes/Combat/Map/Layer.tscn")

const NEW_LAYER = preload("res://Addon/Plugin/NewLayer.tscn")
const NEXT_LAYER = preload("res://Addon/Plugin/NextLayer.tscn")
const PREVIOUS_LAYER = preload("res://Addon/Plugin/PreviousLayer.tscn")

var edited_node : Node = null

var new_layer_button : Button = null
var next_layer_button : Button = null
var previous_layer_button : Button = null

# Initialization
func _enter_tree():
	new_layer_button = generate_button(NEW_LAYER)
	next_layer_button = generate_button(NEXT_LAYER)
	previous_layer_button = generate_button(PREVIOUS_LAYER)
	
	new_layer_button.connect("pressed", self, "_on_new_layer_pressed")
	next_layer_button.connect("pressed", self, "_on_next_layer_pressed")
	previous_layer_button.connect("pressed", self, "_on_previous_layer_pressed")
	
	make_visible(false)


# Instanciate the given button
func generate_button(button_scene: PackedScene) -> Button:
	var new_button = button_scene.instance()
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, new_button)
	return new_button


# Called whenever the handled object is the right one
func edit(object : Object):
	if not object is CombatMap:
		edited_node = object.find_parent("Map")
	else:
		edited_node = object


# Called whenever the user select a node.
# Check if the plugin handle this node or not. 
# If it return true trigger the edit and the make_visible callbacks
func handles(object: Object):
	return object is CombatMap or object.find_parent("Map")


# Clean-up
func _exit_tree():
	if new_layer_button != null:
		new_layer_button.queue_free()
		
	if next_layer_button != null:
		next_layer_button.queue_free()
	
	if previous_layer_button != null:
		previous_layer_button.queue_free()


func make_visible(visible: bool):
	if new_layer_button != null:
		new_layer_button.set_visible(visible)
		next_layer_button.set_visible(visible)
		previous_layer_button.set_visible(visible)


func _on_new_layer_pressed():
	var undo = get_undo_redo()
	var layer : Node = null
	undo.create_action("Add new layer")
	layer = undo.add_do_method(self, "add_layer")
	undo.add_undo_method(self, "delete_layer", layer)
	undo.commit_action()


func add_layer():
	if edited_node == null:
		return null
	
	var layer = LAYER.instance()
	edited_node.add_child(layer)
	layer.owner = edited_node


func delete_layer(layer: Node):
	if layer == null:
		return
	
	layer.queue_free()


func _on_next_layer_pressed():
	pass


func _on_previous_layer_pressed():
	pass
