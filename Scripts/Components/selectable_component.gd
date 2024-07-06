extends Node
class_name SelectableComponent

signal selected
signal deselected

@export var highlight:Node
@export var mouse_hover_component:MouseHoverComponent
@export var collision_object:CollisionObject2D

var can_be_selected:bool = false : set = _toggle_selectability

var is_selected:bool = false

func _ready():
	_set_highlight_visibility()
	_connect_signals()
	
func _connect_signals():
	if collision_object == null:
		printerr("No CollisionObject2D found for " + self.name)
		return
	collision_object.input_event.connect(_input_event)
		
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_handle_mouse_leftclick(event)

func _handle_mouse_leftclick(event):
	if mouse_hover_component == null:
		printerr("MouseHoverComponent not found for " + self.name)
	if mouse_hover_component.mouse_is_on and event.pressed:
		toggle_select()

func select() -> void:
	if can_be_selected && !is_selected:
		is_selected = true
		selected.emit()
		_set_highlight_visibility()
	
func deselect() -> void:
	if is_selected:
		is_selected = false
		deselected.emit()
		_set_highlight_visibility()
	
func toggle_select() -> void:
	if is_selected:
		deselect()
	else:
		select()
		
func _toggle_selectability(value) -> void:
	can_be_selected = value
		
func _set_highlight_visibility() -> void:
	if highlight != null:
		highlight.set_visible(is_selected)
	
