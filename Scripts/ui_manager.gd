extends Control
class_name UiManager

@export var game_manager:GameManager
@export var turn_manager:TurnManager
@export var turn_label:Label
@export var turn_button:Button


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_turn_label(turn_manager.turn)
	_connect_signals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	turn_button.disabled = !turn_manager.can_go_next_turn()

func _connect_signals():
	if turn_manager:
		turn_manager.turn_changed.connect(_update_turn_label)
	turn_button.pressed.connect(turn_manager.next_turn)

func _update_turn_label(turn:int):
	if turn_label:
		turn_label.text = "Turn " + str(turn)
