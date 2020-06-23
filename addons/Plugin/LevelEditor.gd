tool
extends EditorPlugin

const LAYER = preload("res://Scenes/Combat/Map/Layer.tscn")

const NEW_LAYER = preload("res://Addon/Plugin/NewLayer.tscn")
const NEXT_LAYER = preload("res://Addon/Plugin/NextLayer.tscn")
const PREVIOUS_LAYER = preload("res://Addon/Plugin/PreviousLayer.tscn")

var edited_node : Node = null
var edited_layer : Node = null

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
	
	if object is MapLayer:
		edited_layer = object
	else:
		edited_layer = null


# Called whenever the user select a node.
# Check if the plugin handle this node or not. 
# If it return true trigger the edit and the make_visible callbacks
func handles(object: Object):
	return object is CombatMap or (object is Node and 
									object.find_parent("Map"))


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
	var layer = LAYER.instance()
	
	undo.create_action("Add new layer")
	undo.add_do_method(self, "add_layer", layer)
	undo.add_undo_method(edited_node, "remove_child", layer)
	undo.commit_action()


func add_layer(layer: Node):
	if edited_node == null:
		return
	
	edited_node.add_child(layer)
	layer.owner = edited_node


func _on_next_layer_pressed():
	if edited_node == null:
		return
	
	var undo = get_undo_redo()
	
	var editor_selection = get_editor_interface().get_selection()
	var selection_array = editor_selection.get_selected_nodes()
	var selection = selection_array[0]
	
	undo.create_action("Select next layer")
	undo.add_do_method(self, "select_next_previous_layer", true)
	undo.add_undo_method(self, "change_selected_node", selection)
	undo.commit_action()


func _on_previous_layer_pressed():
	if edited_node == null:
		return
	
	var undo = get_undo_redo()
	
	var editor_selection = get_editor_interface().get_selection()
	var selection_array = editor_selection.get_selected_nodes()
	var selection = selection_array[0]
	
	undo.create_action("Select previous layer")
	undo.add_do_method(self, "select_next_previous_layer", false)
	undo.add_undo_method(self, "change_selected_node", selection)
	undo.commit_action()


# Select the next layer. (Or previous if next is false)
# Select the first one if the map is the current selection
func select_next_previous_layer(next : bool = true):
	var editor_selection = get_editor_interface().get_selection()
	var selection_array = editor_selection.get_selected_nodes()
	var selection = selection_array[0]
	var next_layer : MapLayer = null
	
	var undo = get_undo_redo()
	
	# Get the first layer of the map if the selection is the map itself
	if selection is CombatMap:
		var first_layer = get_first_layer(selection)
		if first_layer != null:
			change_selected_node(first_layer)
	else:
		
		# In case of a direct child of the map
		if selection.get_parent() is CombatMap:
			if next:
				next_layer = get_next_layer(edited_node, selection.get_index())
			else:
				next_layer = get_previous_layer(edited_node, selection.get_index())
			
			if next_layer != null:
				change_selected_node(next_layer)
			else: # If the last one is selected, create a new one and select it
				if next:
					var layer = LAYER.instance()
					undo.create_action("Add new layer")
					undo.add_do_method(self, "add_layer", layer)
					undo.add_undo_method(edited_node, "remove_child", layer)
					undo.commit_action()
		
		else: # in case of an indirect child
			var parent_layer = find_parent_layer(selection)
			if parent_layer != null:
				if next :
					next_layer = get_next_layer(edited_node, parent_layer.get_index())
				else:
					next_layer = get_previous_layer(edited_node, parent_layer.get_index())
				change_selected_node(next_layer)


func change_selected_node(node : Node):
	var editor_selection = get_editor_interface().get_selection()
	editor_selection.clear()
	editor_selection.add_node(node)


# Find the first parent that is a layer
func find_parent_layer(node : Node):
	var parent = node.get_parent()
	if parent is MapLayer:
		return parent
	else:
		if parent == get_tree().get_root():
			return null
		else:
			find_parent_layer(parent)


# Return the next layer child of the given map, starting from the given index
func get_next_layer(Map: CombatMap, index : int = 0) -> MapLayer:
	var children = Map.get_children()
	var nb_map_children = children.size()
	if index >= nb_map_children:
		return null
	
	for i in range(index + 1, nb_map_children):
		if children[i] is MapLayer:
			return children[i]
	return null


# Return the next layer child of the given map, starting from the given index
func get_previous_layer(Map: CombatMap, index : int = 0) -> MapLayer:
	var children = Map.get_children()
	for i in range(index - 1, -1, -1):
		if children[i] is MapLayer:
			return children[i]
	return null


# Return the first layer of the given map
func get_first_layer(Map: CombatMap) -> MapLayer:
	for child in Map.get_children():
		if child is MapLayer:
			return child
	return null
