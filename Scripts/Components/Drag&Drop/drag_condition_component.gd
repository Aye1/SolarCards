extends Node
class_name DragConditionComponent

enum DragType
{
	NONE = 0,
	CARD = 1 << 0
}

@export var drag_type:DragType
@export_flags("play", "character") var can_be_played_on

func accepts(drop_cond:DropConditionComponent) -> bool:
	return (drop_cond.drop_type & can_be_played_on) > 0

#static func string_to_drag_type(type:String):
#	match(type):
#		"card":
#			return DragType.CARD
#		_:
#			printerr("Unknown DragType " + type)

