tool
extends EditorPlugin

const LAYER = preload("res://Scenes/Combat/Map/Layer.tscn")

const NEW_LAYER = preload("res://addons/Plugin/NewLayer.tscn")
const NEXT_LAYER = preload("res://addons/Plugin/NextLayer.tscn")
const PREVIOUS_LAYER = preload("res://addons/Plugin/PreviousLayer.tscn")

const combat_scene = preload("res://Scenes/Combat/CombatBase.tscn")

var edited_map : Node = null
var edited_layer : Node = null

var new_layer_button : Button = null
var next_layer_button : Button = null
var previous_layer_button : Button = null

#### BUILT-IN FUNCTIONS ####

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
		edited_map = object.find_parent("Map")
	else:
		edited_map = object
	
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
	var layer = LAYER.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	
	undo.create_action("Add new layer")
	undo.add_do_method(self, "add_layer", layer)
	undo.add_undo_method(edited_map, "remove_child", layer)
	undo.commit_action()

#### SIGNALS REPONSES ####

func _on_next_layer_pressed():
	if edited_map == null:
		return
	
	select_next_action(true)


func _on_previous_layer_pressed():
	if edited_map == null:
		return
	
	select_next_action(false)


func select_next_action(next : bool = true):
	var undo = get_undo_redo()
	
	var editor_selection = get_editor_interface().get_selection()
	var selection_array = editor_selection.get_selected_nodes()
	var selection = selection_array[0]
	
	undo.create_action("Select previous layer")
	undo.add_do_method(self, "select_next_previous_layer", next)
	undo.add_undo_method(self, "change_selected_node", selection)
	undo.commit_action()


#### LOGIC FUNCTIONS ####

# Select the next layer. (Or previous if next is false)
# Select the first one if the map is the current selection
func select_next_previous_layer(next : bool = true):
	var editor_selection = get_editor_interface().get_selection()
	var selection_array = editor_selection.get_selected_nodes()
	var selection = selection_array[0]
	var next_layer : MapLayer = null
	
	# Get the first layer of the map if the selection is the map itself
	if selection is CombatMap:
		var first_layer = edited_map.get_first_layer(selection)
		if first_layer != null:
			change_selected_node(first_layer)
	else:
		
		# In case of a direct child of the map
		if selection.get_parent() is CombatMap:
			if next:
				next_layer = edited_map.get_next_layer(selection.get_index())
			else:
				next_layer = edited_map.get_previous_layer(selection.get_index())
			
			if next_layer != null:
				change_selected_node(next_layer)
			else: # If the last one is selected, create a new one and select it
				if next:
					_on_new_layer_pressed()
		
		else: # in case of an indirect child
			var parent_layer = find_parent_layer(selection)
			if parent_layer != null:
				if next :
					next_layer = edited_map.get_next_layer(parent_layer.get_index())
					if next_layer == null:
						next_layer = edited_map.get_first_layer()
				else:
					next_layer = edited_map.get_previous_layer(parent_layer.get_index())
				change_selected_node(next_layer)


# Set the focus on the given node
# If the given node has a node that has the same name than the current selection
# Set the focus on it instead
func change_selected_node(node : Node):
	var editor_selection = get_editor_interface().get_selection()
	var selection_array = editor_selection.get_selected_nodes()
	var selection_name = selection_array[0].name
	
	editor_selection.clear()
	
	#### TEMPORARY ####
#	editor_selection.add_node(node)
	var targeted_selection = node.get_node_or_null(selection_name)
	if targeted_selection != null:
		editor_selection.add_node(targeted_selection)
	else:
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


func add_layer(layer: Node):
	if edited_map == null:
		return
	
	var edited_scene = get_tree().get_edited_scene_root()
#	var open_scenes = get_editor_interface().get_open_scenes()
#
#	print(open_scenes)
	
	var nb_layers = edited_map.count_layers()
	var last_layer = edited_map.get_last_layer()
	
	# Set the layer offset
	layer.set_position(Vector2(0, nb_layers * -16))
	layer.set_display_folded(false)
	
	# Set the new node to be editable
#	var editable_instances = combat_scene._bundled.get("editable_instances")
#	editable_instances.append("Map/Layer" + String(nb_layers + 1))
#	combat_scene._bundled["editable_instances"] = editable_instances
#	print(combat_scene._bundled["editable_instances"])
	
	edited_map.add_child_below_node(last_layer, layer)
	layer.set_owner(edited_scene)
	get_editor_interface().save_scene()
	
	make_editable(layer)
	
	change_selected_node(layer)


# WIP: makes instanced scene node's children editable (aka "Editable Children")
func make_editable(node : Node):

	var root = get_editor_interface().get_edited_scene_root()
	if not root:
		return

	var root_path = root.filename
	if root_path.empty():
		return

	var root_scene = load(root_path)
	var state = root_scene._bundled
	# This should make [editable path="node"] appear in text scene once saved
	state.editable_instances.push_back(root.get_path_to(node))
	root_scene._bundled = state

#	Current hack:
	get_editor_interface().save_scene()
#	or:
	ResourceSaver.save(root_scene.resource_path, root_scene)
	get_editor_interface().open_scene_from_path(root_scene.resource_path)
