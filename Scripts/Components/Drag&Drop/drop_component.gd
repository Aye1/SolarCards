extends Area2D
class_name DropComponent

@export var drop_conditions:DropConditionComponent
@export var can_receive_drop:bool = false

signal draggable_dropped(draggable, dropzone)

func signal_draggable_dropped(draggable:DraggableComponent):
	draggable_dropped.emit(draggable, self)
