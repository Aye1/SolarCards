extends Area2D
class_name DropZone

signal draggable_dropped(draggable, dropzone)

var current_draggable

func _on_area_entered(area):
	if area is Draggable:
		print("Draggable detected on drop zone")
		current_draggable = area
		area.drag_stopped.connect(_on_draggable_released.bind(area))


func _on_area_exited(area):
	if area == current_draggable:
		current_draggable = null
		area.drag_stopped.disconnect(_on_draggable_released.bind(area))
		
func _on_draggable_released(draggable):
	if draggable == current_draggable:
		_effect(draggable)
		
		
func _effect(draggable):
	draggable_dropped.emit(draggable, self)
