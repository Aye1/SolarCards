extends Node
class_name TurnManager

signal turn_changed(turn:int)

var turn:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func next_turn() -> void:
	if can_go_next_turn():
		turn = turn + 1
		print("Go to turn " + str(turn))
		turn_changed.emit(turn)
	
func can_go_next_turn() -> bool:
	return true
