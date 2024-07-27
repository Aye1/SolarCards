extends Node
class_name DropConditionComponent

enum DropType
{
	NONE = 0,
	PLAY = 1 << 0,
	CHARACTER = 1 << 1
}

@export var drop_type:DropType
@export_flags("card") var can_accept = 0b11

func accepts(drag_cond:DragConditionComponent) -> bool:
	return (drag_cond.drag_type & can_accept) > 0

#static func string_to_drop_type(type:String):
#	match(type):
#		"play":
#			return DropType.PLAY
#		"character":
#			return DropType.CHARACTER
#		_:
#			printerr("Unknown DropType " + type)

