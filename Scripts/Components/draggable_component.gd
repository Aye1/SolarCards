extends Node2D
class_name DraggableComponent

signal drag_started
signal drag_stopped

@export var mouse_hover_component:MouseHoverComponent
@export var collision_object:CollisionObject2D

var is_dragged = false
var is_current_hover = false : set = _set_is_current_hover
var drag_local_point
var can_be_dragged = true
var current_drop_zone

func _ready():
	_connect_signals()
	
func _connect_signals():
	if collision_object == null:
		printerr("No CollisionObject2D found for " + self.name)
		return
	collision_object.input_event.connect(_input_event)
	collision_object.area_entered.connect(_area_entered)
	collision_object.area_exited.connect(_area_exited)
		
func _physics_process(delta):
	_handle_drag()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_handle_mouse_leftclick(event)

func _handle_mouse_leftclick(event):
	if mouse_hover_component == null:
		printerr("MouseHoverComponent not found for " + self.name)
	if mouse_hover_component.mouse_is_on and event.pressed:
		#selected.emit()
		if can_be_dragged:
			is_dragged = true
			drag_started.emit()
			drag_local_point = owner.get_local_mouse_position() * owner.scale
	elif !event.pressed and is_dragged:
		is_dragged = false
		drag_stopped.emit()
		_check_drop_zone()
		
func _handle_drag():
	if is_dragged:
		owner.global_position = get_global_mouse_position() - drag_local_point
		
func _area_entered(area:Area2D):
	# TODO: manage multiple areas
	if area is DropComponent:
		#print("area entered")
		current_drop_zone = area
	
func _area_exited(area:Area2D):
	if area is DropComponent and current_drop_zone == area:
		#print("area exited")
		current_drop_zone = null
		
func _check_drop_zone():
	if current_drop_zone != null and can_be_dragged:
		current_drop_zone.signal_draggable_dropped(self)
		
func _set_is_current_hover(value:bool):
	is_current_hover = value
	mouse_hover_component.can_scale = is_current_hover

func set_can_be_grabbed(can_be):
	can_be_dragged = can_be
	
func set_drop_zone(drop_zone):
	current_drop_zone = drop_zone
