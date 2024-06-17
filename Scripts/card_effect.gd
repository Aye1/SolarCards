extends Object
class_name CardEffect

var type
var value
var target
	
func _init(dict):
	type = dict["type"]
	value = dict["value"]
	target = dict["target"]
