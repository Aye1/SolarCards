extends Resource
class_name CardResource

@export var title:String
@export_enum("action", "character") var type:String
@export var cost:int
@export var desc:String
@export var effects:Array[CardEffectResource]
