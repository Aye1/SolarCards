extends Node2D
class_name CardSelector

signal selection_done(selected_cards, all_cards)

var target_count = 10000
var selectable_cards = []
var selected_cards = []

var accept_button:Button
var displayer:CardDisplayer

# Called when the node enters the scene tree for the first time.
func _ready():
	accept_button = $AcceptButton
	displayer = $CardDisplayer
	displayer.add_cards(selectable_cards)
	_connect_cards()
	accept_button.pressed.connect(_on_accept_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_enable_button_if_possible()

func _enable_button_if_possible():
	accept_button.disabled = !_can_accept()
	
func _can_accept() -> bool:
	return selected_cards.size() == target_count
	
func _connect_cards() -> void:
	for card in selectable_cards:
		card.selectable.can_be_selected = true
		card.selectable.selected.connect(_on_card_selected.bind(card))
		card.selectable.deselected.connect(_on_card_deselected.bind(card))
		card.draggable.can_be_dragged = false
	
func _release_cards():
	for card in selectable_cards:
		card.selectable.can_be_selected = false
		card.selectable.selected.disconnect(_on_card_selected.bind(card))
		card.selectable.deselected.disconnect(_on_card_deselected.bind(card))
		card.draggable.can_be_dragged = true

func _on_card_deselected(card):
	if card in selected_cards:
		selected_cards.erase(card)
		_update_selectability()

func _on_card_selected(card):
	if selected_cards.size() < target_count:
		selected_cards.append(card)
		_update_selectability()

func _update_selectability():
	for card in selectable_cards:
		card.selectable.can_be_selected = !_can_accept()
			
func _on_accept_button_pressed():
	_release_cards()
	selection_done.emit(selected_cards, selectable_cards)

func set_selectable_cards(cards):
	selectable_cards = cards
