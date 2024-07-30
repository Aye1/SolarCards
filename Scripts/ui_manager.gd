extends Control
class_name UiManager

@export var game_manager:GameManager
@export var turn_manager:TurnManager
@export var turn_label:Label
@export var turn_button:Button
@export var inspect_window:Control
@export var card_selector:CardSelector


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
	card_selector.selection_done.connect(_on_card_select_done)

func _update_turn_label(turn:int):
	if turn_label:
		turn_label.text = "Turn " + str(turn)

func display_inspect_window(card):
	if inspect_window:
		inspect_window.visible = true
		
func display_card_selector(cards, target_count, pile, type):
	if card_selector:
		card_selector.visible = true
		card_selector.setup(cards, target_count, pile, type)
		#card_selector.set_selectable_cards(cards)
		#card_selector.target_count = target_count
		#card_selector.selection_type = type

func _on_card_select_done(selected_cards, remaining_cards, pile):
	card_selector.visible = false
	card_selector.clear()
