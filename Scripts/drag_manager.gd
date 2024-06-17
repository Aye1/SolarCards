extends Node
class_name DragManager

signal draggable_released(draggable)

var draggables = []
var currently_dragged
	
func register_draggable(draggable):
	if draggable is Draggable and !draggables.has(draggable):
		draggables.append(draggable)
		draggable.drag_started.connect(_on_draggable_dragged.bind(draggable))
		draggable.drag_stopped.connect(_on_draggable_released.bind(draggable))
		print("draggable registered")
	
func unregister_draggable(draggable):
	if draggable is Draggable and draggables.has(draggable):
		draggables.remove(draggable)
		draggable.drag_started.disconnect(_on_draggable_dragged.bind(draggable))
		draggable.drag_stopped.disconnect(_on_draggable_released.bind(draggable))
		
func _on_draggable_dragged(dragged):
	print(str(dragged.get_instance_id()) + " is being dragged")
	currently_dragged = dragged
	_block_other_draggables()
	
func _on_draggable_released(dragged):
	_unblock_all_dragables()
	draggable_released.emit(dragged)
	
func _block_other_draggables():
	for drag in draggables:
		if drag == null:
			printerr("Null draggable found")
		elif drag != currently_dragged:
			drag.set_can_be_grabbed(false)

func _unblock_all_dragables():
	for drag in draggables:
		if drag == null:
			printerr("Null draggable found")
		else:
			drag.set_can_be_grabbed(true)
