extends CollisionObject2D
class_name Draggable

var mouse_is_on = false
var is_dragged = false
var is_current_hover = false
var drag_local_point
var can_be_dragged = true
var current_drop_zone

signal mouse_on
signal mouse_off
signal drag_started
signal drag_stopped
signal selected

	
func _physics_process(delta):
	_handle_drag()

func _mouse_enter():
	mouse_is_on = true
	mouse_on.emit()

func _mouse_exit():
	mouse_is_on = false
	mouse_off.emit()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_handle_mouse_leftclick(event)

func _handle_mouse_leftclick(event):
	if mouse_is_on and event.pressed:
		selected.emit()
		if can_be_dragged:
			is_dragged = true
			drag_started.emit()
			drag_local_point = owner.get_local_mouse_position() * owner.scale
	elif !event.pressed:
		is_dragged = false
		drag_stopped.emit()
		
func _handle_drag():
	if is_dragged:
		owner.global_position = get_global_mouse_position() - drag_local_point
		
func set_can_be_grabbed(can_be):
	can_be_dragged = can_be
	
func set_drop_zone(drop_zone):
	current_drop_zone = drop_zone
