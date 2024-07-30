extends Node
class_name MouseHoverComponent

signal mouse_on
signal mouse_off

# Used for non-UI objects
@export var collision_object:CollisionObject2D
# Used for UI objects
@export var control:Control
@export var should_scale_on_hover:bool = false
@export_range (0,5) var scale_ratio:float = 1.5
var mouse_is_on:bool = false
var base_scale:Vector2
var hover_scale:Vector2
var can_scale:bool = false

func _ready():
	_connect_signals()
	base_scale = owner.scale
	hover_scale = base_scale * scale_ratio

func _process(delta):
	_handle_scale()
	
func _connect_signals():
	if collision_object:
		collision_object.mouse_entered.connect(_mouse_enter.bind())
		collision_object.mouse_exited.connect(_mouse_exit.bind())
	if control:
		control.mouse_entered.connect(_mouse_enter)
		control.mouse_exited.connect(_mouse_exit)

func _mouse_enter():
	mouse_is_on = true
	mouse_on.emit()

func _mouse_exit():
	mouse_is_on = false
	mouse_off.emit()
	
func _handle_scale():
	if !mouse_is_on:
		owner.scale = base_scale
	elif should_scale_on_hover and can_scale and mouse_is_on:
		owner.scale = hover_scale
