extends Area2D
class_name DropComponent

signal draggable_dropped(draggable, dropzone)

func signal_draggable_dropped(draggable:DraggableComponent):
	draggable_dropped.emit(draggable, self)
