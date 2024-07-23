extends Resource
class_name CardEffectResource

@export_enum("draw", "discard", "draw_discard", "debug_print") var type:String
@export var value:String
@export var value2:String
@export_enum("actions", "location", "none") var target:String
