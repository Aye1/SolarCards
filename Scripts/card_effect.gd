extends Object
class_name CardEffect

var type
var value
var value2
var target
	
func _init(dict):
	type = dict["type"]
	value = dict["value"]
	target = dict["target"]
	if dict.has("value2"):
		value2 = dict["value2"]
