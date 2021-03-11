extends HBoxContainer
class_name ActionOptionContainer

onready var tween = $Tween
onready var label = $Label
onready var texture_rect = $TextureRect
onready var option_button = $MenuOptionBase

onready var default_margin_left = get_margin(MARGIN_LEFT)

export var transition_duration : float = 0.2
export var hidden : bool = true setget set_hidden, is_hidden
export var hidden_margin_left : float = 30.0

var text : String = "BUTTON" setget set_text, get_text
var amount : int = INF setget set_amount, get_amount
var icon_texture : Texture = null setget set_icon_texture, get_icon_texture

var is_ready : bool = false

signal option_chose(option_ref)

#### ACCESSORS ####

func is_class(value: String): return value == "ActionOptionContainer" or .is_class(value)
func get_class() -> String: return "ActionOptionContainer"

func set_hidden(value: bool): hidden = value
func is_hidden() -> bool: return hidden

func set_amount(value: int):
	if !is_ready:
		yield(self, "ready")
	
	amount = value
	
	if amount == int(INF):
		label.queue_free()
		_update_alignment()
		return
	
	if value != int(INF):
		label.set_text(String(amount))
	else: 
		label.set_text("")

func get_amount() -> int: return amount

func set_icon_texture(value: Texture):
	if !is_ready:
		yield(self, "ready")
	
	if icon_texture == null:
		texture_rect.queue_free()
		_update_alignment()
		return 
	
	icon_texture = value
	texture_rect.set_texture(icon_texture)

func get_icon_texture() -> Texture: return icon_texture

func set_text(value: String):
	if !is_ready:
		yield(self, "ready")
	
	text = value
	option_button.set_text(text)
	option_button.set_name(text)


func get_text() -> String: return text


func set_disabled(value: bool):
	if !is_ready:
		yield(self, "ready")
	
	option_button.set_disabled(value)


#### BUILT-IN ####

func _ready() -> void:
	var __ = option_button.connect("option_chose", self, "_on_button_option_chose")
	__ = option_button.connect("focus_changed", self, "_on_focus_changed")
	
	if is_hidden():
		set_margin(MARGIN_LEFT, hidden_margin_left)
		set_modulate(Color.transparent)
	
	is_ready = true

#### VIRTUALS ####



#### LOGIC ####

func appear():
	tween.interpolate_property(self, "modulate",
		Color.transparent, Color.white, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "margin_left",
		hidden_margin_left, default_margin_left, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	set_hidden(false)


func disappear():
	tween.interpolate_property(self, "modulate",
		Color.white, Color.transparent, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "margin_left",
		default_margin_left, hidden_margin_left, transition_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	set_hidden(true)


func _update_alignment():
	if amount == int(INF) && icon_texture == null:
		option_button.set_text_align(Button.ALIGN_RIGHT)
		set_alignment(BoxContainer.ALIGN_END)
	else:
		option_button.set_text_align(Button.ALIGN_LEFT)
		set_alignment(BoxContainer.ALIGN_BEGIN)

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_button_option_chose(option: MenuOptionsBase):
	emit_signal("option_chose", option)

func _on_focus_changed(button: Button, focused: bool):
	if label == null:
		return
	
	if focused:
		label.set_modulate(button.get_color("font_color_hover"))
	else:
		label.set_modulate(button.get_color("font_color"))
