extends Node
class_name MouseHoverComponent

signal mouse_on
signal mouse_off

@export var collision_object:CollisionObject2D
var mouse_is_on:bool = false

func _ready():
	_connect_signals()
	
func _connect_signals():
	if collision_object == null:
		printerr("No CollisionObject2D found for " + self.name)
		return
	collision_object.mouse_entered.connect(_mouse_enter.bind())
	collision_object.mouse_exited.connect(_mouse_exit.bind())

func _mouse_enter():
	mouse_is_on = true
	mouse_on.emit()

func _mouse_exit():
	mouse_is_on = false
	mouse_off.emit()
